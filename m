Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE891F8987
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 17:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgFNPer (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 11:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgFNPeq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jun 2020 11:34:46 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4378FC05BD43;
        Sun, 14 Jun 2020 08:34:45 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id c35so9720310edf.5;
        Sun, 14 Jun 2020 08:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Id64pYRbBdr0TBqpeled8R3k5PmdYvVAt6t3V/jjCCQ=;
        b=kX49cQSl7kp1yZ+Oga508Dv02XZYfB0QKnz4v24WDhWslL69F4SwMY3u8VCACI6+tf
         sEB+KMv5ONbBxA1F7BCpAVIz+nkKhdZ6gjW95iNdoNV3snoIN+XiHm3rUcCWXrvgLC7f
         Cuc9G49HdpjOry/U2gHHTJdguTAl9Gk3YdkyxIsb1E6zU+8WOTqlnWZQUty3y8+HocW6
         PoZeZJQgeZIdECytksOQq3SivFkXCinIISS0JeTjIpbzmdH3oBXToofMl0ST6kJ4nkyb
         8AGytIB2Fg2g43Fi5v1vYRdRRIdxwkIYoikZ0k6/Zn2UnmJ7Lt8qQSaf2zR15GxmJNdt
         +5CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Id64pYRbBdr0TBqpeled8R3k5PmdYvVAt6t3V/jjCCQ=;
        b=MUQpt/P+rOGpBrQ8q0t5w8Bng4yoqz8vLzxoR3nvNwab6JG89Sd4YRXVslnr5QVFjt
         tmuVuRZg4fO4+LVGTCgtOuL/cE4IFDRLU5aUYkPSDNKIt7QvaRWTG9uMIfm7sG0X3eiD
         gk6qHA8vMa9IGtvTFzA+5Jwp5tas86wYyJrqMgvE3VVrWwBCvr4hQG/IpVo2APpR9kpJ
         o7uBL9Hk7b4OKO2kl9UvMNoE77w0YUiIsy4xbLVvLXeKeaZdS9q5MC7DeILsIQjJCafW
         VyoSRB+wV9gfoqpxNnZ5MtbiATVO9XYvotDf6cOzPNfqFppMqzX1zY/3VT+YkYqRqpYk
         Ry/A==
X-Gm-Message-State: AOAM533ydDGHB8JlQmLjK/aygFLw16nl9edJPaIOoK+QVZbhVeXKKfqj
        O5J/P05JPQEyjhtZbmSwOoko/pgHmEto2lSA/rM=
X-Google-Smtp-Source: ABdhPJwYThxdT3/zlJ9GGkqEiEpTFgbAbzTs3Gd0m56kYeLsLefZyPVi6KWleTkdPvBvyD0x6jQyErmyTdlR712QhRM=
X-Received: by 2002:aa7:dc50:: with SMTP id g16mr20995265edu.318.1592148884697;
 Sun, 14 Jun 2020 08:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
 <1592132154-20175-2-git-send-email-krzk@kernel.org> <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
 <20200614111829.GA9694@kozik-lap> <CA+h21hqE3RbD2XTBbcRsMhsO2OaZ65tAaevFOr00p9ezu8O+iA@mail.gmail.com>
 <CA+h21hoVjJkGyxTEnh2Bixjoqxb12k-KK37U4Xy-27ntZz8aTw@mail.gmail.com> <20200614151247.GA2494@kozik-lap>
In-Reply-To: <20200614151247.GA2494@kozik-lap>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 14 Jun 2020 18:34:33 +0300
Message-ID: <CA+h21hotvdXUgUzMaVfb_6EM-9kcoHvvnT4r+EHx7m6z4R0pxg@mail.gmail.com>
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

On Sun, 14 Jun 2020 at 18:12, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>
> On Sun, Jun 14, 2020 at 04:43:28PM +0300, Vladimir Oltean wrote:
> > On Sun, 14 Jun 2020 at 16:39, Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Sun, 14 Jun 2020 at 14:18, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > >
> > > > On Sun, Jun 14, 2020 at 02:14:15PM +0300, Vladimir Oltean wrote:
> > > > > On Sun, 14 Jun 2020 at 13:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > > > >
> > > > > > If interrupt fires early, the dspi_interrupt() could complete
> > > > > > (dspi->xfer_done) before its initialization happens.
> > > > > >
> > > > > > Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
> >
> > Also please note that this patch merely replaced an
> > init_waitqueue_head with init_completion. But the "bug" (if we can
> > call it that) originates from even before.
>
> Yeah, I know, the Fixes is not accurate. Backport to earlier kernels
> would be manual so I am not sure if accurate Fixes matter.
>
> >
> > > > > > Cc: <stable@vger.kernel.org>
> > > > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > > > > ---
> > > > >
> > > > > Why would an interrupt fire before spi_register_controller, therefore
> > > > > before dspi_transfer_one_message could get called?
> > > > > Is this master or slave mode?
> > > >
> > > > I guess practically it won't fire.  It's more of a matter of logical
> > > > order and:
> > > > 1. Someone might fix the CONFIG_DEBUG_SHIRQ_FIXME one day,
> > >
> > > And what if CONFIG_DEBUG_SHIRQ_FIXME gets fixed? I uncommented it, and
> > > still no issues. dspi_interrupt checks the status bit of the hw, sees
> > > there's nothing to do, and returns IRQ_NONE.
>
> Indeed, still the logical way of initializing is to do it before any
> possible use.
>
> > >
> > > > 2. The hardware is actually initialized before and someone could attach
> > > >    to SPI bus some weird device.
> > > >
> > >
> > > Some weird device that does what?
>
> You never know what people will connect to a SoM :).
>
> Wolfram made actually much better point - bootloaders are known to
> initialize some things and leaving them in whatever state, assuming that
> Linux kernel will redo any initialization properly.
>
> Best regards,
> Krzysztof
>

I don't buy the argument.
So ok, maybe some broken bootloader leaves a SPI_SR interrupt pending
(do you have any example of that?). But the driver clears interrupts
by writing SPI_SR_CLEAR in dspi_init (called _before_ requesting the
IRQ). It clears 10 bits from the status register. There are 2 points
to be made here:
- The dspi_interrupt only handles data availability interrupt
(SPI_SR_EOQF | SPI_SR_CMDTCF). Only then does it matter whether the
completion was already initialized or not. But these interrupts _are_
cleared. But assume they weren't. What would Linux even do with a SPI
transfer initiated by the previously running software environment? Why
would it be a smart thing to handle that data in the first place?
- The 10 bits from the status register are all the bits that can be
cleared. The rest of the register, if you look at it, contains the TX
FIFO Counter, the Transmit Next Pointer, the RX FIFO Counter, and the
Pop Next Pointer.
So, unless there's something I'm missing, I don't actually see how
this broken bootloader can do any harm to us.

Thanks,
-Vladimir
