Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCCC8697F
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404790AbfHHTIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404324AbfHHTIA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45D97214C6;
        Thu,  8 Aug 2019 19:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291279;
        bh=aFWjAWnkNgkPjMjUQKqFytHObHuRsWgRZDmqE8Vo808=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJQRK6wSZfLSYxpmSYAP8JOzswqHySRAs0IdCHrAW3oTxPJQZZlAUmSIPrWwu0ph5
         hB32dSGPTsW8E+MITjepCL0JyK6H55gTP85EAuk2vvLUhGJ/4YHDNJ75EaFt6ldZKY
         ckUzv91R3Rkp3u8k22wEr0950Z86VgeREa/wDez8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Lukas Wunner <lukas@wunner.de>,
        Martin Sperl <kernel@martin.sperl.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.2 56/56] spi: bcm2835: Fix 3-wire mode if DMA is enabled
Date:   Thu,  8 Aug 2019 21:05:22 +0200
Message-Id: <20190808190455.622676210@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 8d8bef50365847134b51c1ec46786bc2873e4e47 upstream.

Commit 6935224da248 ("spi: bcm2835: enable support of 3-wire mode")
added 3-wire support to the BCM2835 SPI driver by setting the REN bit
(Read Enable) in the CS register when receiving data.  The REN bit puts
the transmitter in high-impedance state.  The driver recognizes that
data is to be received by checking whether the rx_buf of a transfer is
non-NULL.

Commit 3ecd37edaa2a ("spi: bcm2835: enable dma modes for transfers
meeting certain conditions") subsequently broke 3-wire support because
it set the SPI_MASTER_MUST_RX flag which causes spi_map_msg() to replace
rx_buf with a dummy buffer if it is NULL.  As a result, rx_buf is
*always* non-NULL if DMA is enabled.

Reinstate 3-wire support by not only checking whether rx_buf is non-NULL,
but also checking that it is not the dummy buffer.

Fixes: 3ecd37edaa2a ("spi: bcm2835: enable dma modes for transfers meeting certain conditions")
Reported-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v4.2+
Cc: Martin Sperl <kernel@martin.sperl.org>
Acked-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/328318841455e505370ef8ecad97b646c033dc8a.1562148527.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm2835.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -764,7 +764,8 @@ static int bcm2835_spi_transfer_one(stru
 	bcm2835_wr(bs, BCM2835_SPI_CLK, cdiv);
 
 	/* handle all the 3-wire mode */
-	if ((spi->mode & SPI_3WIRE) && (tfr->rx_buf))
+	if (spi->mode & SPI_3WIRE && tfr->rx_buf &&
+	    tfr->rx_buf != master->dummy_rx)
 		cs |= BCM2835_SPI_CS_REN;
 	else
 		cs &= ~BCM2835_SPI_CS_REN;


