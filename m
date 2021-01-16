Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D782F8EBD
	for <lists+stable@lfdr.de>; Sat, 16 Jan 2021 19:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbhAPStg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Jan 2021 13:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbhAPStf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Jan 2021 13:49:35 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1406FC061573;
        Sat, 16 Jan 2021 10:48:55 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id z6so1456983qtn.0;
        Sat, 16 Jan 2021 10:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X2bjEjVEcanHHKTBZQZPkGXKfsmOeDviCXiXcIortNA=;
        b=E1DjK98MWwxC9OkCtVHta5dUI7MLDAvrsR0TTAZmHI8g4zacVwt6yyAcoLdOvSk4/D
         leuILrkRvmamwJrbpmae25ufFCxNT23soThLZBj2hILrawRfUr1aRE2UXkXLGTr8fqtZ
         4HT3MZmB8jK+JnAqcufAUHvfQ9KBW4CykRNaxuNfSGafPkxb9qz6SEJRriyboqtu/pqM
         2ftIOF0eww4zJZ9uJiHVaIyaTbvCMaSWpSoIHaX3OsKCq8o6cz/o+VshLxstAOqQdWEO
         H5m6i1H8wWDonPXrVwNYZUW9gKz2j+bBrUwMqc4ew3/KJBQ4wmFBsmlAqV7LquEbufzH
         FIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X2bjEjVEcanHHKTBZQZPkGXKfsmOeDviCXiXcIortNA=;
        b=C0z/TtFvDCrIdi4N3W9kjeuYYOd5u/7rhJEdFeidAys3PT8pDHDmPjWIZ6qJvlwnG6
         MmBW8NSud+knWTL5tXgATlQk5Yu8CUr+/WTbatdYewRw6gQRgoUBepe00E3rHo2oMKnj
         Ymc/TIb7nI6yzGGLTbqqbHyeSOa+2h/D04zrft25FM0yYXKLtCCQnWPf2DXeeVgqd9rx
         yigiXSK10AtFKZF2P/Mm1W/b9ZocugCZZVgWypXABmrRY2nwKmEODG6MOWEj710q3Lv1
         S8Hp8yvPircZbLjeoVeyF61y0HmcZSebErJEz9QDyXN0jjOpdkb8OJkGmT9mH6gl/mh4
         AYOQ==
X-Gm-Message-State: AOAM533RoGIy/XTfHUPoFpxX1qAvF0arqG+7DVjq6tejCOUC7J7uhWoz
        B5qlFy62sZ1qguIn5RKdepA=
X-Google-Smtp-Source: ABdhPJyQKmaEeMDeSGS4BpTCiU37UOmFMliYbbat4DvjsbQ8mH9NkLCyk39bekIGaMT65pN5ARSajg==
X-Received: by 2002:ac8:6cf:: with SMTP id j15mr16800710qth.180.1610822934151;
        Sat, 16 Jan 2021 10:48:54 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id n66sm7395327qkn.136.2021.01.16.10.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 10:48:53 -0800 (PST)
Date:   Sat, 16 Jan 2021 11:48:51 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 5.4 40/62] spi: spi-geni-qcom: Fix geni_spi_isr() NULL
 dereference in timeout case
Message-ID: <20210116184851.GA2491015@ubuntu-m3-large-x86>
References: <20210115121958.391610178@linuxfoundation.org>
 <20210115122000.333323971@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115122000.333323971@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 01:28:02PM +0100, Greg Kroah-Hartman wrote:
> From: Douglas Anderson <dianders@chromium.org>
> 
> commit 4aa1464acbe3697710279a4bd65cb4801ed30425 upstream.
> 
> In commit 7ba9bdcb91f6 ("spi: spi-geni-qcom: Don't keep a local state
> variable") we changed handle_fifo_timeout() so that we set
> "mas->cur_xfer" to NULL to make absolutely sure that we don't mess
> with the buffers from the previous transfer in the timeout case.
> 
> Unfortunately, this caused the IRQ handler to dereference NULL in some
> cases.  One case:
> 
>   CPU0                           CPU1
>   ----                           ----
>                                  setup_fifo_xfer()
>                                   geni_se_setup_m_cmd()
>                                  <hardware starts transfer>
>                                  <transfer completes in hardware>
>                                  <hardware sets M_RX_FIFO_WATERMARK_EN in m_irq>
>                                  ...
>                                  handle_fifo_timeout()
>                                   spin_lock_irq(mas->lock)
>                                   mas->cur_xfer = NULL
>                                   geni_se_cancel_m_cmd()
>                                   spin_unlock_irq(mas->lock)
> 
>   geni_spi_isr()
>    spin_lock(mas->lock)
>    if (m_irq & M_RX_FIFO_WATERMARK_EN)
>     geni_spi_handle_rx()
>      mas->cur_xfer NULL dereference!
> 
> tl;dr: Seriously delayed interrupts for RX/TX can lead to timeout
> handling setting mas->cur_xfer to NULL.
> 
> Let's check for the NULL transfer in the TX and RX cases and reset the
> watermark or clear out the fifo respectively to put the hardware back
> into a sane state.
> 
> NOTE: things still could get confused if we get timeouts all the way
> through handle_fifo_timeout() and then start a new transfer because
> interrupts from the old transfer / cancel / abort could still be
> pending.  A future patch will help this corner case.
> 
> Fixes: 561de45f72bd ("spi: spi-geni-qcom: Add SPI driver support for GENI based QUP")
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> Reviewed-by: Stephen Boyd <swboyd@chromium.org>
> Link: https://lore.kernel.org/r/20201217142842.v3.1.I99ee04f0cb823415df59bd4f550d6ff5756e43d6@changeid
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/spi/spi-geni-qcom.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> --- a/drivers/spi/spi-geni-qcom.c
> +++ b/drivers/spi/spi-geni-qcom.c
> @@ -415,6 +415,12 @@ static void geni_spi_handle_tx(struct sp
>  	unsigned int bytes_per_fifo_word = geni_byte_per_fifo_word(mas);
>  	unsigned int i = 0;
>  
> +	/* Stop the watermark IRQ if nothing to send */
> +	if (!mas->cur_xfer) {
> +		writel(0, se->base + SE_GENI_TX_WATERMARK_REG);
> +		return false;
> +	}
> +
>  	max_bytes = (mas->tx_fifo_depth - mas->tx_wm) * bytes_per_fifo_word;
>  	if (mas->tx_rem_bytes < max_bytes)
>  		max_bytes = mas->tx_rem_bytes;
> @@ -454,6 +460,14 @@ static void geni_spi_handle_rx(struct sp
>  		if (rx_last_byte_valid && rx_last_byte_valid < 4)
>  			rx_bytes -= bytes_per_fifo_word - rx_last_byte_valid;
>  	}
> +
> +	/* Clear out the FIFO and bail if nowhere to put it */
> +	if (!mas->cur_xfer) {
> +		for (i = 0; i < DIV_ROUND_UP(rx_bytes, bytes_per_fifo_word); i++)
> +			readl(se->base + SE_GENI_RX_FIFOn);
> +		return;
> +	}
> +
>  	if (mas->rx_rem_bytes < rx_bytes)
>  		rx_bytes = mas->rx_rem_bytes;
>  
> 
> 

This commit breaks the build with clang:

drivers/spi/spi-geni-qcom.c:421:3: error: void function
'geni_spi_handle_tx' should not return a value [-Wreturn-type]
                return false;
                ^      ~~~~~
1 error generated.

It looks like commit 6d66507d9b55 ("spi: spi-geni-qcom: Don't wait to
start 1st transfer if transmitting") would resolve this.

It might be worth picking up commit 172aad81a882 ("kbuild: enforce
-Werror=return-type") so that GCC behaves like clang does.

Cheers,
Nathan
