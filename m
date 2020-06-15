Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E17B1F9765
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 14:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbgFOM4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 08:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729977AbgFOM4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 08:56:14 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8103C061A0E;
        Mon, 15 Jun 2020 05:56:13 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w16so16779760ejj.5;
        Mon, 15 Jun 2020 05:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qXYey5+z4XH/ze0CWdNcvFvzyDDniwsSZOKQE4KvrPA=;
        b=LWzYj+YUZE5h3uCy+V+oKermAdgPdGS6C8qL9LwMjPW6ITfnP0y2Dgs05yw/ayjMJu
         RgJGJgRKxJtjJsprQaWp+UM3lJME/REUZLhE9zN06FpCC3UFkmHHEJrFrmCe7NeTfb6P
         4viYgcN2myPkYCNOsbzttBX+tLoaW9BysLcBm6es9LK4wCQeyy8bmdhxBERMvuPilICH
         NJANq3gd8DooJJODqZF5xLp8nWmuka+rLmFf2vfjj2VkOSVTvqyB2mUMzkytFygDICaj
         etrCk9Km4O4ORHSnyhRPAlXYC5wu2pPYjB7Rc/jlmQdZ/xOxJFX2yNYUBlzYXyqSo+oY
         goBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qXYey5+z4XH/ze0CWdNcvFvzyDDniwsSZOKQE4KvrPA=;
        b=CjEsxxm55eC0ZxoYho8VfsBOy74pIXDF49Sc7OwWyZtZQZc++i/R1vaWrtBw+QL5To
         qEWJZAxwrX6X1iYSOkZfRiw4hN2M+ZjZEPd8o1lVCTUQ4VBP5N/xsjScUxqFuFa+BG5N
         bNWvVFLsgiTZQvIWGEJj/fDgQ8f2TC4tZ1cjs3wX+C5jF/vw137w0jdKLs2oZLS+OEr2
         rYl5Miqy4UGMbNqsPHP0EfWOrCet6rC4e+dL2lzKWuNtyRulCAKynzeDycMaKMyA/3kY
         kCtS/h5ZAD5/FgGlwcIOAI4EHJdc2kvYDUio1NLCFuewVxxysLkQlVBPSfwBsWBaETCP
         LlNw==
X-Gm-Message-State: AOAM530FhIG2cDYRukDKdZmm/4W47/csOXzHIQjMPdse08Ab8MtNn+BK
        zzrkoAfdsK6MUAad5v1xiYQXXMewO63+mBzac2E=
X-Google-Smtp-Source: ABdhPJxfD2eZnT7OjVjtGV+km3Oywp2EPuv/r9jJrK8yqXO8qIUu5maBk1Ir2ArbyCoC4j5QFo4imEk0dhb/iB+WsQo=
X-Received: by 2002:a17:906:851:: with SMTP id f17mr24343551ejd.396.1592225772600;
 Mon, 15 Jun 2020 05:56:12 -0700 (PDT)
MIME-Version: 1.0
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de> <20200615123052.GO4447@sirena.org.uk>
In-Reply-To: <20200615123052.GO4447@sirena.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 15 Jun 2020 15:56:01 +0300
Message-ID: <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] spi: spi-fsl-dspi: Fix external abort on interrupt
 in exit paths
To:     Mark Brown <broonie@kernel.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Jun 2020 at 15:35, Mark Brown <broonie@kernel.org> wrote:
>

>
> Indeed.  The upshot of all this is that the interrupt needs to be freed
> not disabled before the clocks are disabled, or some other mechanism
> needs to be used to ensure that the interrupt handler won't attempt to
> access the hardware when it shouldn't.  As Vladimir says there are
> serious issues using devm for interrupt handlers (or anything else that
> might cause code to be run) due to problems like this.

And the down-shot is that whatever is done in dspi_remove (free_irq)
also needs to be done in dspi_suspend, but with extra care in
dspi_resume not only to request the irq again, but also to flush the
module's FIFOs and clear interrupts, because there might have been
nasty stuff uncaught during sleep:

    regmap_update_bits(dspi->regmap, SPI_MCR,
               SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF,
               SPI_MCR_CLR_TXF | SPI_MCR_CLR_RXF);
    regmap_write(dspi->regmap, SPI_SR, SPI_SR_CLEAR);

So it's pretty messy.

-Vladimir
