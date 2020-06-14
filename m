Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9091F88FA
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 15:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgFNNjU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 09:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgFNNjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jun 2020 09:39:19 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5BDC05BD43;
        Sun, 14 Jun 2020 06:39:19 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id e12so9595518eds.2;
        Sun, 14 Jun 2020 06:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ch1266/zLQhz11J/+T8ColOn8pjWDCQ6/ckZ8J1yAl4=;
        b=nNonRJopASXRG5nObKu0LEYyym18LPtY8KURjqoJgMC0vG+gVDWHqCqIqIJb4ZsY3d
         X4fDPZ3OzpPvIry/xKfkUUQsVaHDk1cWY+Z3sobHOq+pUoyAVcDu8RWHsoRNX8A17T85
         sMzprL0d2PA/KJDVCsRmI5FqWn7rNGddVScMfSV3v1uSdyx0aRn8HO/HCYgQE2b/BxuR
         GplWnRLjahxEqSd+IJs7JIsBAUJ42El8XUWOEVcHN369ds7pTpE+GfQh+TrB8DS5Yycl
         968Xmu7GNN0uKJqeMh+LgjgWvHv8QYkCyr6MnTG/9oCcKuwHZVTxHoCzkTBFvr4hH0E6
         jzKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ch1266/zLQhz11J/+T8ColOn8pjWDCQ6/ckZ8J1yAl4=;
        b=Dw1m7sLgaMJnCo5+31u/hjMwzGbmnwRkGe5iRMQd3C4RQQJlg8j0yzcY3S2Kd3zOek
         KhRVZFAMRBevgsZcnsJFvVO7nbxnFbdX/tiYj5jd9MyEpxhevX1or+5qPxWQf7zSZzQi
         K6tQ9Zo1g6j7wLYfOt6mHXcCRRdkfPmiZneV7sn5DyOJaEmi1uiUxkFTl0ndKSkxuXsa
         zmDGZRQ3p8PTVcVWqHZaMmQQqhgaKZGfPgUchamdO1vRqWTYqFjCnPzlFofXbUtZKPPC
         GFUD98tLXkgixPYneevKTq7tv1yrC61T4iqWXkCZxRwZE9Agp88wYnwEr9DWKSH7lgjt
         WycQ==
X-Gm-Message-State: AOAM533G8PUdvdZiweNIfkj900TCeimpOm2Vl33uQz0QxrXdCyzAL64P
        macssTckbdwGssENjNdGvyKwxrBM6BKdBmvY1PhjIDrN
X-Google-Smtp-Source: ABdhPJxXCFyPqjmcEIxdCuTNrj6k9PPvCHw30V0XgyEfXpgSbQGtTVaZNoE3ULLuubEmdP3+bn0x5BYTBAdDu+cudQs=
X-Received: by 2002:a05:6402:545:: with SMTP id i5mr20256115edx.179.1592141954827;
 Sun, 14 Jun 2020 06:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
 <1592132154-20175-2-git-send-email-krzk@kernel.org> <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
 <20200614111829.GA9694@kozik-lap>
In-Reply-To: <20200614111829.GA9694@kozik-lap>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 14 Jun 2020 16:39:03 +0300
Message-ID: <CA+h21hqE3RbD2XTBbcRsMhsO2OaZ65tAaevFOr00p9ezu8O+iA@mail.gmail.com>
Subject: Re: [PATCH 2/2] spi: spi-fsl-dspi: Initialize completion before
 possible interrupt
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 14 Jun 2020 at 14:18, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Sun, Jun 14, 2020 at 02:14:15PM +0300, Vladimir Oltean wrote:
> > On Sun, 14 Jun 2020 at 13:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > >
> > > If interrupt fires early, the dspi_interrupt() could complete
> > > (dspi->xfer_done) before its initialization happens.
> > >
> > > Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > ---
> >
> > Why would an interrupt fire before spi_register_controller, therefore
> > before dspi_transfer_one_message could get called?
> > Is this master or slave mode?
>
> I guess practically it won't fire.  It's more of a matter of logical
> order and:
> 1. Someone might fix the CONFIG_DEBUG_SHIRQ_FIXME one day,

And what if CONFIG_DEBUG_SHIRQ_FIXME gets fixed? I uncommented it, and
still no issues. dspi_interrupt checks the status bit of the hw, sees
there's nothing to do, and returns IRQ_NONE.

> 2. The hardware is actually initialized before and someone could attach
>    to SPI bus some weird device.
>

Some weird device that does what?

> Best regards,
> Krzysztof
>

Thanks,
-Vladimir
