Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65B62F9261
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 13:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbhAQMyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 07:54:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbhAQMyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 07:54:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 435CC2076A;
        Sun, 17 Jan 2021 12:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610888049;
        bh=OXM4XbMJ6QQVz8VYx4+SysOclFuL8aP8ZUCK9YtR55M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UoqMHdLR2pouvFP/08J8Xb8te1Iq+jy+o6sqiPO59kzUrIdzIQanw1YGuwERRGi7t
         Qh5KhTXbzRr5ovnzvKfOhN4es6HgQWDcz0evqpcqsD87IH5Tjb7g0QjWJ/3dRwYBop
         hDBn/sS+ZTTEE5KKxU6mglJqsA2nWKNikWa8h4cg=
Date:   Sun, 17 Jan 2021 13:54:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 5.4 40/62] spi: spi-geni-qcom: Fix geni_spi_isr() NULL
 dereference in timeout case
Message-ID: <YAQzb6ywnWL3Go1W@kroah.com>
References: <20210115121958.391610178@linuxfoundation.org>
 <20210115122000.333323971@linuxfoundation.org>
 <20210116184851.GA2491015@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116184851.GA2491015@ubuntu-m3-large-x86>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 16, 2021 at 11:48:51AM -0700, Nathan Chancellor wrote:
> On Fri, Jan 15, 2021 at 01:28:02PM +0100, Greg Kroah-Hartman wrote:
> > From: Douglas Anderson <dianders@chromium.org>
> > 
> > commit 4aa1464acbe3697710279a4bd65cb4801ed30425 upstream.
> > 
> > In commit 7ba9bdcb91f6 ("spi: spi-geni-qcom: Don't keep a local state
> > variable") we changed handle_fifo_timeout() so that we set
> > "mas->cur_xfer" to NULL to make absolutely sure that we don't mess
> > with the buffers from the previous transfer in the timeout case.
> > 
> > Unfortunately, this caused the IRQ handler to dereference NULL in some
> > cases.  One case:
> > 
> >   CPU0                           CPU1
> >   ----                           ----
> >                                  setup_fifo_xfer()
> >                                   geni_se_setup_m_cmd()
> >                                  <hardware starts transfer>
> >                                  <transfer completes in hardware>
> >                                  <hardware sets M_RX_FIFO_WATERMARK_EN in m_irq>
> >                                  ...
> >                                  handle_fifo_timeout()
> >                                   spin_lock_irq(mas->lock)
> >                                   mas->cur_xfer = NULL
> >                                   geni_se_cancel_m_cmd()
> >                                   spin_unlock_irq(mas->lock)
> > 
> >   geni_spi_isr()
> >    spin_lock(mas->lock)
> >    if (m_irq & M_RX_FIFO_WATERMARK_EN)
> >     geni_spi_handle_rx()
> >      mas->cur_xfer NULL dereference!
> > 
> > tl;dr: Seriously delayed interrupts for RX/TX can lead to timeout
> > handling setting mas->cur_xfer to NULL.
> > 
> > Let's check for the NULL transfer in the TX and RX cases and reset the
> > watermark or clear out the fifo respectively to put the hardware back
> > into a sane state.
> > 
> > NOTE: things still could get confused if we get timeouts all the way
> > through handle_fifo_timeout() and then start a new transfer because
> > interrupts from the old transfer / cancel / abort could still be
> > pending.  A future patch will help this corner case.
> > 
> > Fixes: 561de45f72bd ("spi: spi-geni-qcom: Add SPI driver support for GENI based QUP")
> > Signed-off-by: Douglas Anderson <dianders@chromium.org>
> > Reviewed-by: Stephen Boyd <swboyd@chromium.org>
> > Link: https://lore.kernel.org/r/20201217142842.v3.1.I99ee04f0cb823415df59bd4f550d6ff5756e43d6@changeid
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  drivers/spi/spi-geni-qcom.c |   14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> > 
> > --- a/drivers/spi/spi-geni-qcom.c
> > +++ b/drivers/spi/spi-geni-qcom.c
> > @@ -415,6 +415,12 @@ static void geni_spi_handle_tx(struct sp
> >  	unsigned int bytes_per_fifo_word = geni_byte_per_fifo_word(mas);
> >  	unsigned int i = 0;
> >  
> > +	/* Stop the watermark IRQ if nothing to send */
> > +	if (!mas->cur_xfer) {
> > +		writel(0, se->base + SE_GENI_TX_WATERMARK_REG);
> > +		return false;
> > +	}
> > +
> >  	max_bytes = (mas->tx_fifo_depth - mas->tx_wm) * bytes_per_fifo_word;
> >  	if (mas->tx_rem_bytes < max_bytes)
> >  		max_bytes = mas->tx_rem_bytes;
> > @@ -454,6 +460,14 @@ static void geni_spi_handle_rx(struct sp
> >  		if (rx_last_byte_valid && rx_last_byte_valid < 4)
> >  			rx_bytes -= bytes_per_fifo_word - rx_last_byte_valid;
> >  	}
> > +
> > +	/* Clear out the FIFO and bail if nowhere to put it */
> > +	if (!mas->cur_xfer) {
> > +		for (i = 0; i < DIV_ROUND_UP(rx_bytes, bytes_per_fifo_word); i++)
> > +			readl(se->base + SE_GENI_RX_FIFOn);
> > +		return;
> > +	}
> > +
> >  	if (mas->rx_rem_bytes < rx_bytes)
> >  		rx_bytes = mas->rx_rem_bytes;
> >  
> > 
> > 
> 
> This commit breaks the build with clang:
> 
> drivers/spi/spi-geni-qcom.c:421:3: error: void function
> 'geni_spi_handle_tx' should not return a value [-Wreturn-type]
>                 return false;
>                 ^      ~~~~~
> 1 error generated.
> 
> It looks like commit 6d66507d9b55 ("spi: spi-geni-qcom: Don't wait to
> start 1st transfer if transmitting") would resolve this.
> 
> It might be worth picking up commit 172aad81a882 ("kbuild: enforce
> -Werror=return-type") so that GCC behaves like clang does.

Argh, I thought I had dropped this before, but no.  Good catch, I've
dropped it now.

And yes, that might be a good patch to backport (the gcc one), I'll
queue that up next round, thanks.

greg k-h
