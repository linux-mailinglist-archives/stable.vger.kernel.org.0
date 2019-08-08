Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3F985AE1
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 08:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbfHHGdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 02:33:38 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:34523 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbfHHGdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Aug 2019 02:33:37 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Aug 2019 02:33:35 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id BF92F2800B3C2;
        Thu,  8 Aug 2019 08:23:29 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 8FDD5CA7; Thu,  8 Aug 2019 08:23:29 +0200 (CEST)
Date:   Thu, 8 Aug 2019 08:23:29 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     broonie@kernel.org, kernel@martin.sperl.org, nuno.sa@analog.com,
        wahrenst@gmx.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835: Fix 3-wire mode if DMA is
 enabled" failed to apply to 5.2-stable tree
Message-ID: <20190808062329.njfou4kfqwlz24qn@wunner.de>
References: <156519648724814@kroah.com>
 <20190807205849.ualpzgp52crdmdol@wunner.de>
 <20190808055625.GA24491@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190808055625.GA24491@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 08, 2019 at 07:56:25AM +0200, Greg KH wrote:
> On Wed, Aug 07, 2019 at 10:58:49PM +0200, Lukas Wunner wrote:
> > On Wed, Aug 07, 2019 at 06:48:07PM +0200, gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 5.2-stable tree.
> 
> The patch applies everywhere, but breaks the build in all trees.

Ugh, yes you are right, my apologies.

The reason is that v5.3 converted spi-bcm2835.c to use the
"spi_controller" nomenclature instead of "spi_master" with
commit 5f336ea53b6b ("spi: bcm2835: Replace spi_master by
spi_controller").

The replacement patch below should hopefully not break the
build.  It's the same as upstream commit 8d8bef503658,
except one occurrence of "ctlr" is replaced by "master".

Thanks!

-- >8 --
From 8d8bef50365847134b51c1ec46786bc2873e4e47 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 3 Jul 2019 12:29:31 +0200
Subject: [PATCH] spi: bcm2835: Fix 3-wire mode if DMA is enabled
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 6f243a90c844..840b1b8ff3dc 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -834,7 +834,8 @@ static int bcm2835_spi_transfer_one(struct spi_master *master,
 	bcm2835_wr(bs, BCM2835_SPI_CLK, cdiv);
 
 	/* handle all the 3-wire mode */
-	if ((spi->mode & SPI_3WIRE) && (tfr->rx_buf))
+	if (spi->mode & SPI_3WIRE && tfr->rx_buf &&
+	    tfr->rx_buf != master->dummy_rx)
 		cs |= BCM2835_SPI_CS_REN;
 	else
 		cs &= ~BCM2835_SPI_CS_REN;

