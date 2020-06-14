Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E23B1F8900
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 15:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgFNNnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 09:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgFNNnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jun 2020 09:43:42 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B91C05BD43;
        Sun, 14 Jun 2020 06:43:41 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id o15so14593553ejm.12;
        Sun, 14 Jun 2020 06:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2JK7KGekdKk92ix3V6dwBOemAX4+Cg95WIG/xENrDWE=;
        b=T0mKqtpAN81wMzgDobYRYrqAnj8bInha1NepnPIo9ZA5+Lgsq36OAfiUIraExtvObP
         CrNmGqwyEEpj1gHZySt2CgOFimTsdV3zTGEDo8vYKz0QFdhHJajZT7X9U3cjIAmPkHbW
         RXX3igy5p/2eRLIfSBepdR9Ix295sfi8U+dh9zSmiK6OWk4ZLo3UGq1YQGdcqSOJHh5u
         bhdP4H9INgNyhIDQzbh0jpChNy4VySKyAixC0Ad1jkpiWLmh9/XO8syEL4IJO7Ez3LhX
         AnrtXna3C68MG6yDx/dKeH50IwTMlHacBYPkOD8kTL+Id72b9gj/vjPPHZiKd5fkywKI
         uOLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2JK7KGekdKk92ix3V6dwBOemAX4+Cg95WIG/xENrDWE=;
        b=OztdUO/8RtSSAS6eUDcniga6zzC67yY6Yc8VkqcIx9dFC1WM8i5RxHrzuLX0/UHXIN
         +5+RcRWRektJnJRiHtUuzqoN+hvBWkWLJSiBi8zrI6+TauXsGnaOWBlbWx642iyuQlK4
         jAviZob+mb8hCheIVGdn7N8xD9zvclttgGpzGaja4IQ+dfRCfNGLNzaVVV68F7aMIF2F
         j2+cAWPDQmlajNZIMKoSKSaYchRD5f0Y4U9WoJSz48qYDrcdgSzRTUJ1U4tL5A6rMQ/z
         9xmpb/AKlN/muoMzXORPnNHuKgvX91QEq9K2l4yI9nMyvXJqQpnRkKWUl3xjJJ2uR30O
         f7ww==
X-Gm-Message-State: AOAM532jAZNtvHx0CaYi08SVF6UIi+8HyEjtnDr8AV735IJwwqr1V6np
        +V1JbxjCLoKWJIn2X5Qi+TR20hqrHlCzpAR2bWvAx9Ow
X-Google-Smtp-Source: ABdhPJxiLRhSn1vMvYdXG7qmdlKCmTZBmxhXrnyzgCKNUwOdM4r6MtZBxiGiHYXZfbA+EBEpchAae7BeldKLnUxJ7T0=
X-Received: by 2002:a17:906:1149:: with SMTP id i9mr22576193eja.100.1592142220162;
 Sun, 14 Jun 2020 06:43:40 -0700 (PDT)
MIME-Version: 1.0
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
 <1592132154-20175-2-git-send-email-krzk@kernel.org> <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
 <20200614111829.GA9694@kozik-lap> <CA+h21hqE3RbD2XTBbcRsMhsO2OaZ65tAaevFOr00p9ezu8O+iA@mail.gmail.com>
In-Reply-To: <CA+h21hqE3RbD2XTBbcRsMhsO2OaZ65tAaevFOr00p9ezu8O+iA@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 14 Jun 2020 16:43:28 +0300
Message-ID: <CA+h21hoVjJkGyxTEnh2Bixjoqxb12k-KK37U4Xy-27ntZz8aTw@mail.gmail.com>
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

On Sun, 14 Jun 2020 at 16:39, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Sun, 14 Jun 2020 at 14:18, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >
> > On Sun, Jun 14, 2020 at 02:14:15PM +0300, Vladimir Oltean wrote:
> > > On Sun, 14 Jun 2020 at 13:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > >
> > > > If interrupt fires early, the dspi_interrupt() could complete
> > > > (dspi->xfer_done) before its initialization happens.
> > > >
> > > > Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")

Also please note that this patch merely replaced an
init_waitqueue_head with init_completion. But the "bug" (if we can
call it that) originates from even before.

> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > > ---
> > >
> > > Why would an interrupt fire before spi_register_controller, therefore
> > > before dspi_transfer_one_message could get called?
> > > Is this master or slave mode?
> >
> > I guess practically it won't fire.  It's more of a matter of logical
> > order and:
> > 1. Someone might fix the CONFIG_DEBUG_SHIRQ_FIXME one day,
>
> And what if CONFIG_DEBUG_SHIRQ_FIXME gets fixed? I uncommented it, and
> still no issues. dspi_interrupt checks the status bit of the hw, sees
> there's nothing to do, and returns IRQ_NONE.
>
> > 2. The hardware is actually initialized before and someone could attach
> >    to SPI bus some weird device.
> >
>
> Some weird device that does what?
>
> > Best regards,
> > Krzysztof
> >
>
> Thanks,
> -Vladimir
