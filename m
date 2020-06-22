Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D383920422C
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 22:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgFVUvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 16:51:32 -0400
Received: from mail.baikalelectronics.com ([87.245.175.226]:45422 "EHLO
        mail.baikalelectronics.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728421AbgFVUvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 16:51:32 -0400
Received: from localhost (unknown [127.0.0.1])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id B03E78030809;
        Mon, 22 Jun 2020 20:51:23 +0000 (UTC)
X-Virus-Scanned: amavisd-new at baikalelectronics.ru
Received: from mail.baikalelectronics.ru ([127.0.0.1])
        by localhost (mail.baikalelectronics.ru [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zrSYLP8U0TZk; Mon, 22 Jun 2020 23:51:22 +0300 (MSK)
Date:   Mon, 22 Jun 2020 23:51:21 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Pavel Machek <pavel@denx.de>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Georgy Vlasov <Georgy.Vlasov@baikalelectronics.ru>,
        Ramil Zaripov <Ramil.Zaripov@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Rob Herring <robh+dt@kernel.org>, <linux-mips@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 182/267] spi: dw: Return any value retrieved from
 the dma_transfer callback
Message-ID: <20200622205121.4xuki7guyj6u5yul@mobilestation>
References: <20200619141648.840376470@linuxfoundation.org>
 <20200619141657.498868116@linuxfoundation.org>
 <20200619210719.GB12233@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200619210719.GB12233@amd>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Pavel

On Fri, Jun 19, 2020 at 11:07:19PM +0200, Pavel Machek wrote:
> On Fri 2020-06-19 16:32:47, Greg Kroah-Hartman wrote:
> > From: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > 
> > [ Upstream commit f0410bbf7d0fb80149e3b17d11d31f5b5197873e ]
> > 
> > DW APB SSI DMA-part of the driver may need to perform the requested
> > SPI-transfer synchronously. In that case the dma_transfer() callback
> > will return 0 as a marker of the SPI transfer being finished so the
> > SPI core doesn't need to wait and may proceed with the SPI message
> > trasnfers pumping procedure. This will be needed to fix the problem
> > when DMA transactions are finished, but there is still data left in
> > the SPI Tx/Rx FIFOs being sent/received. But for now make dma_transfer
> > to return 1 as the normal dw_spi_transfer_one() method.
> 

> As far as I understand, this is support for new SoC, not a fix?

Not really. That patch is a first one of a series fixing a problem with
SPI transfer completion:
33726eff3d98 spi: dw: Add SPI Rx-done wait method to DMA-based transfer
1ade2d8a72f9 spi: dw: Add SPI Tx-done wait method to DMA-based transfer
bdbdf0f06337 spi: dw: Locally wait for the DMA transfers completion
f0410bbf7d0f spi: dw: Return any value retrieved from the dma_transfer callback

In anyway having just first commit applied is harmless, though pretty much
pointless in fixing the problem it had been originally introduced for. But it
can be useful for something else. See my comment below.

> 
> > +++ b/drivers/spi/spi-dw.c
> > @@ -383,11 +383,8 @@ static int dw_spi_transfer_one(struct spi_controller *master,
> >  
> >  	spi_enable_chip(dws, 1);
> >  
> > -	if (dws->dma_mapped) {
> > -		ret = dws->dma_ops->dma_transfer(dws, transfer);
> > -		if (ret < 0)
> > -			return ret;
> > -	}
> > +	if (dws->dma_mapped)
> > +		return dws->dma_ops->dma_transfer(dws, transfer);
> >  
> >  	if (chip->poll_mode)
> >  		return poll_transfer(dws);
> 

> Mainline patch simply changes return value, but code is different in
> v4.19, and poll_transfer will now be avoided when dws->dma_mapped. Is
> that a problem?

Actually no.) In that old 4.19 context it's even better to return straight away
no matter what value is returned by the dma_transfer() callback. In the code
without this patch applied, the transfer_one() method will check the poll_mode
flag state even if the dma_transfer() returns a positive value. The positive
value (1) means that the DMA transfer has been executed and the SPI core must
wait for its completion. Needless to say, that if the poll_mode flag state
gets to be true, then a poll-transfer will be executed alongside with the DMA
transfer. Which as you understand will be very wrong. So by having this patch
applied we implicitly fix that problem. Although a probability of the
problematic situation is very low, since the DW APB SSI driver poll-mode hasn't
been utilized by any SPI client driver since long time ago...

-Sergey

> 
> Best regards,
> 									Pavel
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html


