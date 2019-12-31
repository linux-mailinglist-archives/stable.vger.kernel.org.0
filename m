Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFB9612D548
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 01:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbfLaAar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 19:30:47 -0500
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:46366 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbfLaAaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 19:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=Date:Message-Id:In-Reply-To:
        Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:References:
        List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
        List-Archive; bh=DROXetT+eBIXdqH8ADWOFTU5N4oiRNZmfVjong4RfCY=; b=PoBL7PMZH0xO
        3+SQ5Z1vbsPaU/xMdrJPLfy8ju2pfJ5b2rm2ggJJ5TK2vEmlcolsWBeIfU7HgVP9sCpD3XB6TDM8v
        LPWerwGPjQxxpHU4EgBPNoeDIUtzMkvZUQ3JMQ8KWeikH/k+XmzlVhGazDwDIhl0hOqZu8AZOtpx/
        57fKk=;
Received: from cpc102320-sgyl38-2-0-cust46.18-2.cable.virginm.net ([82.37.168.47] helo=fitzroy.sirena.org.uk)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <broonie@sirena.org.uk>)
        id 1im5Qn-0002p8-Lp; Tue, 31 Dec 2019 00:30:41 +0000
Received: by fitzroy.sirena.org.uk (Postfix, from userid 1000)
        id 3103ED01A24; Tue, 31 Dec 2019 00:30:41 +0000 (GMT)
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     broonie@kernel.org, Chuanhua Han <chuanhua.han@nxp.com>,
        Esben Haabendal <eha@deif.com>, linux-spi@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, stable@vger.kernel.org
Subject: Applied "spi: spi-fsl-dspi: Fix 16-bit word order in 32-bit XSPI mode" to the spi tree
In-Reply-To:  <20191228135536.14284-1-olteanv@gmail.com>
Message-Id:  <applied-20191228135536.14284-1-olteanv@gmail.com>
X-Patchwork-Hint: ignore
Date:   Tue, 31 Dec 2019 00:30:41 +0000 (GMT)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch

   spi: spi-fsl-dspi: Fix 16-bit word order in 32-bit XSPI mode

has been applied to the spi tree at

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi.git 

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.  

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark

From ca59d5a51690d5b9340343dc36792a252e9414ae Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 28 Dec 2019 15:55:36 +0200
Subject: [PATCH] spi: spi-fsl-dspi: Fix 16-bit word order in 32-bit XSPI mode

When used in Extended SPI mode on LS1021A, the DSPI controller wants to
have the least significant 16-bit word written first to the TX FIFO.

In fact, the LS1021A reference manual says:

33.5.2.4.2 Draining the TX FIFO

When Extended SPI Mode (DSPIx_MCR[XSPI]) is enabled, if the frame size
of SPI Data to be transmitted is more than 16 bits, then it causes two
Data entries to be popped from TX FIFO simultaneously which are
transferred to the shift register. The first of the two popped entries
forms the 16 least significant bits of the SPI frame to be transmitted.

So given the following TX buffer:

 +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
 | 0x0 | 0x1 | 0x2 | 0x3 | 0x4 | 0x5 | 0x6 | 0x7 | 0x8 | 0x9 | 0xa | 0xb |
 +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
 |     32-bit word 1     |     32-bit word 2     |     32-bit word 3     |
 +-----------------------+-----------------------+-----------------------+

The correct way that a little-endian system should transmit it on the
wire when bits_per_word is 32 is:

0x03020100
0x07060504
0x0b0a0908

But it is actually transmitted as following, as seen with a scope:

0x01000302
0x05040706
0x09080b0a

It appears that this patch has been submitted at least once before:
https://lkml.org/lkml/2018/9/21/286
but in that case Chuanhua Han did not manage to explain the problem
clearly enough and the patch did not get merged, leaving XSPI mode
broken.

Fixes: 8fcd151d2619 ("spi: spi-fsl-dspi: XSPI FIFO handling (in TCFQ mode)")
Cc: Esben Haabendal <eha@deif.com>
Cc: Chuanhua Han <chuanhua.han@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20191228135536.14284-1-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
 drivers/spi/spi-fsl-dspi.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 9c3934efe2b1..8428b69c858b 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -587,21 +587,14 @@ static void dspi_tcfq_write(struct fsl_dspi *dspi)
 	dspi->tx_cmd |= SPI_PUSHR_CMD_CTCNT;
 
 	if (dspi->devtype_data->xspi_mode && dspi->bits_per_word > 16) {
-		/* Write two TX FIFO entries first, and then the corresponding
-		 * CMD FIFO entry.
+		/* Write the CMD FIFO entry first, and then the two
+		 * corresponding TX FIFO entries.
 		 */
 		u32 data = dspi_pop_tx(dspi);
 
-		if (dspi->cur_chip->ctar_val & SPI_CTAR_LSBFE) {
-			/* LSB */
-			tx_fifo_write(dspi, data & 0xFFFF);
-			tx_fifo_write(dspi, data >> 16);
-		} else {
-			/* MSB */
-			tx_fifo_write(dspi, data >> 16);
-			tx_fifo_write(dspi, data & 0xFFFF);
-		}
 		cmd_fifo_write(dspi);
+		tx_fifo_write(dspi, data & 0xFFFF);
+		tx_fifo_write(dspi, data >> 16);
 	} else {
 		/* Write one entry to both TX FIFO and CMD FIFO
 		 * simultaneously.
-- 
2.20.1

