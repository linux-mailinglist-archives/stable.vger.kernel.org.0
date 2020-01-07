Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50EA213340F
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgAGVBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:01:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727718AbgAGVBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:01:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3F2C20880;
        Tue,  7 Jan 2020 21:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430872;
        bh=qDrQ+33CHWZV4nRnVcpf/XWgb+cVikmzpwVUPGJhj9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V37lMZVzwKk0SnAfwcOxPeyubQOMdwYoX0A6B05Io4Cl2jSnhSd2nDKm1y4UdoTc5
         MvKFTJKeYsgCS86uKV2XX8h2OQhQjm5UgbKprLgkIXiV6nwCjDDfNYGVPGMTU+99dH
         ylACYMUUBibl6jl+3GMW2vP6XPxgQQMQU3c1iogs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Esben Haabendal <eha@deif.com>,
        Chuanhua Han <chuanhua.han@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 132/191] spi: spi-fsl-dspi: Fix 16-bit word order in 32-bit XSPI mode
Date:   Tue,  7 Jan 2020 21:54:12 +0100
Message-Id: <20200107205340.035666053@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

commit ca59d5a51690d5b9340343dc36792a252e9414ae upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-dspi.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -583,21 +583,14 @@ static void dspi_tcfq_write(struct fsl_d
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


