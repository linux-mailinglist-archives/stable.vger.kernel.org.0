Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1131F97F6
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgFONKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:10:19 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35939 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729875AbgFONKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:10:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id q11so17089329wrp.3;
        Mon, 15 Jun 2020 06:10:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dYUzTCoFGyBENEloMMCzFkHMfOOssrsDD4uM84BbR08=;
        b=eeoTmkiOEtoDNOdzhAUncodKBwcJPnkZ4MiKftVLI2/hcfQyaM1dDKC12vlaPdVSIH
         1g7vGt7m5r7ZxeI2QFGbwmynf6fwJN1tQsqI8slzNV/vWBLpssaBJoYQRY/VrFt5AzZ0
         f6ZvmfP9EXpOJ58XbRuIjJxFwwPwEFOeXDMxXMr/YocNHxZ4v2Kv7L4W6WdhBN+Odbld
         B4nKDP4BkqiNfN8cYAniDf2RJtTpnbvgfK4FtRXSrZ+8rqAAxitMTNBX8z+ELkhEBwA1
         cNCzAdC6cykN6Ou0Qf4pKiJSawsqi7j9417Iq+OXlIaBkqJg0LVA9cwJhHcSOC7zUqOv
         boCg==
X-Gm-Message-State: AOAM531HwayWkR6XwITHfIHfuz5gw4adGaMvhBheZDCYwHntTUKfDnAZ
        9KAvcmqy5gxmnJpsb2wdkXk=
X-Google-Smtp-Source: ABdhPJyLnu06r/CbDv2MdEiSxhkkK7D975PI6JosQ62hvmRw+7zgyO4BPUO6/BYO29eSgcE1jwGg0g==
X-Received: by 2002:a5d:4cd1:: with SMTP id c17mr28679368wrt.199.1592226615248;
        Mon, 15 Jun 2020 06:10:15 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id o82sm23173112wmo.40.2020.06.15.06.10.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jun 2020 06:10:14 -0700 (PDT)
Date:   Mon, 15 Jun 2020 15:10:12 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on
 interrupt in exit paths
Message-ID: <20200615131012.GB2634@kozik-lap>
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
 <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 03:56:01PM +0300, Vladimir Oltean wrote:
> On Mon, 15 Jun 2020 at 15:35, Mark Brown <broonie@kernel.org> wrote:
> >
> 
> >
> > Indeed.  The upshot of all this is that the interrupt needs to be freed
> > not disabled before the clocks are disabled, or some other mechanism
> > needs to be used to ensure that the interrupt handler won't attempt to
> > access the hardware when it shouldn't.  As Vladimir says there are
> > serious issues using devm for interrupt handlers (or anything else that
> > might cause code to be run) due to problems like this.
> 
> And the down-shot is that whatever is done in dspi_remove (free_irq)
> also needs to be done in dspi_suspend, but with extra care in
> dspi_resume not only to request the irq again, but also to flush the
> module's FIFOs and clear interrupts, because there might have been
> nasty stuff uncaught during sleep:
> 
>     regmap_update_bits(dspi->regmap, SPI_MCR,
>                SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF,
>                SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF);
>     regmap_write(dspi->regmap, SPI_SR, SPI_SR_CLEAR);
> 
> So it's pretty messy.

It is a slightly different bug which so this patch should have a follow
up.

Best regards,
Krzysztof

