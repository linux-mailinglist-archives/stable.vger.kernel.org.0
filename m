Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273601F8977
	for <lists+stable@lfdr.de>; Sun, 14 Jun 2020 17:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgFNPMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Jun 2020 11:12:53 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38866 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgFNPMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Jun 2020 11:12:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id c35so9696582edf.5;
        Sun, 14 Jun 2020 08:12:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pXf+9dtzzm6A97xwI2jlmo0hWvabn12gHNzGHXfcFq0=;
        b=t+dC4sVbWT49TnBxreYn1kdDWXusrXEerjg3Yj3NRbSDXgqGk+qXfUT4HyKzTce2hg
         Lk3Z3dr9uhy04BL9Fd4u6X+s/v5JhNQeRB0ZOoh2216fhMy+dvjP1iwjvJsx36mLX/+k
         8LCwtIf89fGvaxb0gWs6NZNYTVBRhCbDTz4LizqPz+n1CC06VbLkPPMxJPwEG0Rx3gBO
         EbIdyfrTJvRbE3NiM36n13SKA85QXZpCmX/S390kG3HkE70dO0ggjAX2x7ZxOtMxU11T
         5ZqWeltUgo6gtOqMzrQKpqDnU8X+bNvjVCJ2cqMWxlMUucucNFHQvg37D5cqah54ofH5
         uQpw==
X-Gm-Message-State: AOAM530oVIL1wvkR35jdAioG06XkQiIV3f4RTMH/GBlgP6Tw/3ld/1z3
        J9lb1wIq7cl+vh5jq4SEM+4=
X-Google-Smtp-Source: ABdhPJwg6H4LSJOfgMUQ1Y0HV4ws4QLsMZDoOy+9RpWfhHandFMrpjez05/qk4UeD9ov+ev5Us8lHA==
X-Received: by 2002:aa7:c2c7:: with SMTP id m7mr19925837edp.148.1592147570528;
        Sun, 14 Jun 2020 08:12:50 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id l8sm7255755ejc.85.2020.06.14.08.12.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 14 Jun 2020 08:12:49 -0700 (PDT)
Date:   Sun, 14 Jun 2020 17:12:47 +0200
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
Message-ID: <20200614151247.GA2494@kozik-lap>
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
 <1592132154-20175-2-git-send-email-krzk@kernel.org>
 <CA+h21ho_pa0H2MG-aAmUCFj37aYW4es-2V75P4KL-Zjq7qtfRQ@mail.gmail.com>
 <20200614111829.GA9694@kozik-lap>
 <CA+h21hqE3RbD2XTBbcRsMhsO2OaZ65tAaevFOr00p9ezu8O+iA@mail.gmail.com>
 <CA+h21hoVjJkGyxTEnh2Bixjoqxb12k-KK37U4Xy-27ntZz8aTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+h21hoVjJkGyxTEnh2Bixjoqxb12k-KK37U4Xy-27ntZz8aTw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 14, 2020 at 04:43:28PM +0300, Vladimir Oltean wrote:
> On Sun, 14 Jun 2020 at 16:39, Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Sun, 14 Jun 2020 at 14:18, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > >
> > > On Sun, Jun 14, 2020 at 02:14:15PM +0300, Vladimir Oltean wrote:
> > > > On Sun, 14 Jun 2020 at 13:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > > >
> > > > > If interrupt fires early, the dspi_interrupt() could complete
> > > > > (dspi->xfer_done) before its initialization happens.
> > > > >
> > > > > Fixes: 4f5ee75ea171 ("spi: spi-fsl-dspi: Replace interruptible wait queue with a simple completion")
> 
> Also please note that this patch merely replaced an
> init_waitqueue_head with init_completion. But the "bug" (if we can
> call it that) originates from even before.

Yeah, I know, the Fixes is not accurate. Backport to earlier kernels
would be manual so I am not sure if accurate Fixes matter.

> 
> > > > > Cc: <stable@vger.kernel.org>
> > > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > > > ---
> > > >
> > > > Why would an interrupt fire before spi_register_controller, therefore
> > > > before dspi_transfer_one_message could get called?
> > > > Is this master or slave mode?
> > >
> > > I guess practically it won't fire.  It's more of a matter of logical
> > > order and:
> > > 1. Someone might fix the CONFIG_DEBUG_SHIRQ_FIXME one day,
> >
> > And what if CONFIG_DEBUG_SHIRQ_FIXME gets fixed? I uncommented it, and
> > still no issues. dspi_interrupt checks the status bit of the hw, sees
> > there's nothing to do, and returns IRQ_NONE.

Indeed, still the logical way of initializing is to do it before any
possible use.

> >
> > > 2. The hardware is actually initialized before and someone could attach
> > >    to SPI bus some weird device.
> > >
> >
> > Some weird device that does what?

You never know what people will connect to a SoM :).

Wolfram made actually much better point - bootloaders are known to
initialize some things and leaving them in whatever state, assuming that
Linux kernel will redo any initialization properly.

Best regards,
Krzysztof

