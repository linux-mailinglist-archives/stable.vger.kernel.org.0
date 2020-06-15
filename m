Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E7D1F8F0B
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 09:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgFOHJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 03:09:05 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37365 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728224AbgFOHJE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 03:09:04 -0400
Received: by mail-wm1-f66.google.com with SMTP id y20so13631363wmi.2;
        Mon, 15 Jun 2020 00:09:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CzfiXSV5cv7JLhyjK1ps65bA0pz2gJTN5WUTi/AVjOM=;
        b=Ynqo/ZRH0gR10UId3L/C36REV49+nHSDWTgP5p9D+v4EHXr4Jpq3vZYPxgxL8yvEQe
         yDmPclSLHKtMA6B3u7cZr5VmRdbuQlXTM1dHT+u6ZdLmqB2FnRe2e9ojtevQLTCDE8Qb
         xDP81R64LD2W9sUkOcxRHs9b4n65CmMHmULi0GByu0pw8QI+EslOruTh2BhWGx/5/eEP
         /WENJ1BnOkTGig2WKU0m5VV2u3g97SnDNGJHd/gVUEtsO4KmREn+3+rOrjraoV7ab1YJ
         8yVw+9QArnIIHBMBHQWauw4rQqXbQHuym6f/HbbB9kdVx3dlQ+EV6NsjpoGncP9sODSB
         vLoA==
X-Gm-Message-State: AOAM531fzIkdX9q5QGi+7di7UbxlupwlBtJekDN+2BXYe0VN6ekEIS6o
        5ktwth0J8tsustVFH/BTkhU=
X-Google-Smtp-Source: ABdhPJzUIpT/J8Oc+27seBA+4hhWIDmKRQV06drUxgz+9d2MuJiRDSIu5lQ4AQFOeS2bTs/qq+d86A==
X-Received: by 2002:a1c:bb0b:: with SMTP id l11mr12131646wmf.31.1592204941742;
        Mon, 15 Jun 2020 00:09:01 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id g82sm21623498wmf.1.2020.06.15.00.09.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jun 2020 00:09:00 -0700 (PDT)
Date:   Mon, 15 Jun 2020 09:08:58 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] spi: spi-fsl-dspi: Initialize completion before
 possible interrupt
Message-ID: <20200615070858.GA20941@kozik-lap>
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
 <1592132154-20175-2-git-send-email-krzk@kernel.org>
 <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
 <20200614111829.GA9694@kozik-lap>
 <CA+h21hqE3RbD2XTBbcRsMhsO2OaZ65tAaevFOr00p9ezu8O+iA@mail.gmail.com>
 <CA+h21hoVjJkGyxTEnh2Bixjoqxb12k-KK37U4Xy-27ntZz8aTw@mail.gmail.com>
 <20200614151247.GA2494@kozik-lap>
 <CA+h21hotvdXUgUzMaVfb_6EM-9kcoHvvnT4r+EHx7m6z4R0pxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+h21hotvdXUgUzMaVfb_6EM-9kcoHvvnT4r+EHx7m6z4R0pxg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 14, 2020 at 06:34:33PM +0300, Vladimir Oltean wrote:
> On Sun, 14 Jun 2020 at 18:12, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >
> > On Sun, Jun 14, 2020 at 04:43:28PM +0300, Vladimir Oltean wrote:
> > > On Sun, 14 Jun 2020 at 16:39, Vladimir Oltean <olteanv@gmail.com> wrote:
> > > >
> > > > On Sun, 14 Jun 2020 at 14:18, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > > >
> > > > > On Sun, Jun 14, 2020 at 02:14:15PM +0300, Vladimir Oltean wrote:
> > > > > > On Sun, 14 Jun 2020 at 13:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > > > > >
> > > > > > > If interrupt fires early, the dspi_interrupt() could complete
> > > > > > > (dspi->xfer_done) before its initialization happens.
> > > > > > >
> > > > > > > Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
> > >
> > > Also please note that this patch merely replaced an
> > > init_waitqueue_head with init_completion. But the "bug" (if we can
> > > call it that) originates from even before.
> >
> > Yeah, I know, the Fixes is not accurate. Backport to earlier kernels
> > would be manual so I am not sure if accurate Fixes matter.
> >
> > >
> > > > > > > Cc: <stable@vger.kernel.org>
> > > > > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > > > > > ---
> > > > > >
> > > > > > Why would an interrupt fire before spi_register_controller, therefore
> > > > > > before dspi_transfer_one_message could get called?
> > > > > > Is this master or slave mode?
> > > > >
> > > > > I guess practically it won't fire.  It's more of a matter of logical
> > > > > order and:
> > > > > 1. Someone might fix the CONFIG_DEBUG_SHIRQ_FIXME one day,
> > > >
> > > > And what if CONFIG_DEBUG_SHIRQ_FIXME gets fixed? I uncommented it, and
> > > > still no issues. dspi_interrupt checks the status bit of the hw, sees
> > > > there's nothing to do, and returns IRQ_NONE.
> >
> > Indeed, still the logical way of initializing is to do it before any
> > possible use.
> >
> > > >
> > > > > 2. The hardware is actually initialized before and someone could attach
> > > > >    to SPI bus some weird device.
> > > > >
> > > >
> > > > Some weird device that does what?
> >
> > You never know what people will connect to a SoM :).
> >
> > Wolfram made actually much better point - bootloaders are known to
> > initialize some things and leaving them in whatever state, assuming that
> > Linux kernel will redo any initialization properly.
> >
> > Best regards,
> > Krzysztof
> >
> 
> I don't buy the argument.
> So ok, maybe some broken bootloader leaves a SPI_SR interrupt pending
> (do you have any example of that?). But the driver clears interrupts
> by writing SPI_SR_CLEAR in dspi_init (called _before_ requesting the
> IRQ). It clears 10 bits from the status register. There are 2 points
> to be made here:
> - The dspi_interrupt only handles data availability interrupt
> (SPI_SR_EOQF | SPI_SR_CMDTCF). Only then does it matter whether the
> completion was already initialized or not. But these interrupts _are_
> cleared. But assume they weren't. What would Linux even do with a SPI
> transfer initiated by the previously running software environment? Why
> would it be a smart thing to handle that data in the first place?
> - The 10 bits from the status register are all the bits that can be
> cleared. The rest of the register, if you look at it, contains the TX
> FIFO Counter, the Transmit Next Pointer, the RX FIFO Counter, and the
> Pop Next Pointer.
> So, unless there's something I'm missing, I don't actually see how
> this broken bootloader can do any harm to us.

Let's rephrase it: you think therefore that completion should be
initialzed *after* requesting shared interrupts? You think that exactly
that order shall be used in the source code?

Best regards,
Krzysztof


