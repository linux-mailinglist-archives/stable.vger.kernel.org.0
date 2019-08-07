Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEEE0854EC
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 23:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbfHGVHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 17:07:38 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:54747 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729960AbfHGVHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 17:07:38 -0400
X-Greylist: delayed 525 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Aug 2019 17:07:36 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 31454100AF90C;
        Wed,  7 Aug 2019 22:58:50 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id D94C4263D6; Wed,  7 Aug 2019 22:58:49 +0200 (CEST)
Date:   Wed, 7 Aug 2019 22:58:49 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     gregkh@linuxfoundation.org
Cc:     broonie@kernel.org, kernel@martin.sperl.org, nuno.sa@analog.com,
        wahrenst@gmx.net, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: bcm2835: Fix 3-wire mode if DMA is
 enabled" failed to apply to 5.2-stable tree
Message-ID: <20190807205849.ualpzgp52crdmdol@wunner.de>
References: <156519648724814@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <156519648724814@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 07, 2019 at 06:48:07PM +0200, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.2-stable tree.

That's odd, it works for me:

$ git fetch linux-stable
$ git checkout linux-stable/linux-5.2.y
Checking out files: 100% (43562/43562), done.
HEAD is now at 5697a9d... Linux 5.2.7
$ git am /tmp/pt
Applying: spi: bcm2835: Fix 3-wire mode if DMA is enabled

Could you be a little more specific why it couldn't be applied
when you tried it?

Thanks,

Lukas

> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 8d8bef50365847134b51c1ec46786bc2873e4e47 Mon Sep 17 00:00:00 2001
> From: Lukas Wunner <lukas@wunner.de>
> Date: Wed, 3 Jul 2019 12:29:31 +0200
> Subject: [PATCH] spi: bcm2835: Fix 3-wire mode if DMA is enabled
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
> 
> Commit 6935224da248 ("spi: bcm2835: enable support of 3-wire mode")
> added 3-wire support to the BCM2835 SPI driver by setting the REN bit
> (Read Enable) in the CS register when receiving data.  The REN bit puts
> the transmitter in high-impedance state.  The driver recognizes that
> data is to be received by checking whether the rx_buf of a transfer is
> non-NULL.
> 
> Commit 3ecd37edaa2a ("spi: bcm2835: enable dma modes for transfers
> meeting certain conditions") subsequently broke 3-wire support because
> it set the SPI_MASTER_MUST_RX flag which causes spi_map_msg() to replace
> rx_buf with a dummy buffer if it is NULL.  As a result, rx_buf is
> *always* non-NULL if DMA is enabled.
> 
> Reinstate 3-wire support by not only checking whether rx_buf is non-NULL,
> but also checking that it is not the dummy buffer.
> 
> Fixes: 3ecd37edaa2a ("spi: bcm2835: enable dma modes for transfers meeting certain conditions")
> Reported-by: Nuno Sá <nuno.sa@analog.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: stable@vger.kernel.org # v4.2+
> Cc: Martin Sperl <kernel@martin.sperl.org>
> Acked-by: Stefan Wahren <wahrenst@gmx.net>
> Link: https://lore.kernel.org/r/328318841455e505370ef8ecad97b646c033dc8a.1562148527.git.lukas@wunner.de
> Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
> index 6f243a90c844..840b1b8ff3dc 100644
> --- a/drivers/spi/spi-bcm2835.c
> +++ b/drivers/spi/spi-bcm2835.c
> @@ -834,7 +834,8 @@ static int bcm2835_spi_transfer_one(struct spi_controller *ctlr,
>  	bcm2835_wr(bs, BCM2835_SPI_CLK, cdiv);
>  
>  	/* handle all the 3-wire mode */
> -	if ((spi->mode & SPI_3WIRE) && (tfr->rx_buf))
> +	if (spi->mode & SPI_3WIRE && tfr->rx_buf &&
> +	    tfr->rx_buf != ctlr->dummy_rx)
>  		cs |= BCM2835_SPI_CS_REN;
>  	else
>  		cs &= ~BCM2835_SPI_CS_REN;
> 
