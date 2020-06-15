Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7881F9B1C
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 16:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbgFOO5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 10:57:17 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40081 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730652AbgFOO5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 10:57:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id r15so15150729wmh.5;
        Mon, 15 Jun 2020 07:57:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mHcrbBO+Fo3bCvnKiSJoGOEsXEa+5QUFU82tEXS61oo=;
        b=ogcYxfeBxA3qwa97mzrPW4jopWKMl64hXm7wg3STD1q+94yNg/pyj0DXYNIJfvSOQT
         azvYNagX3x48ssnmy+HICSeQ2mkqKvnCs2zl9PU5Yj78VmJW6Lqy2vhHl0nmbcZV/649
         w8vkmTP+K5H+jRoSaw5eRCWd3CT8Lr0zstF1/8VNEiXajHcuHSAKjpIoNnVhBOQE510m
         LKUUEKVpyNKoZAV3ZMq8TRtpgEdtHwSN8H80hyALfXvVZs5VnK/IZas882+H30MCsHU7
         U4uu/U/K3UKJNxMKH5oY4DoC+3XrOvRdimldFlX+9CVqmDw34Jwn7h55Ij8Yj1SlOps2
         m2Uw==
X-Gm-Message-State: AOAM533t3mN9LVm+kKdihYnfkL7IFG8kPLbsu+IVn0cwfVWqLUDdeQlx
        KY1FV+M9ItiPOfq0Nv5DCjE=
X-Google-Smtp-Source: ABdhPJxeN+YKTx2rDQYMG6z/DLFGaJz5APWUznLyEEfgFrNUKvASgGOX1PuuNkKdoJhfxX4g/JUpFA==
X-Received: by 2002:a1c:7903:: with SMTP id l3mr13169484wme.50.1592233034481;
        Mon, 15 Jun 2020 07:57:14 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id s8sm24402667wrm.96.2020.06.15.07.57.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jun 2020 07:57:13 -0700 (PDT)
Date:   Mon, 15 Jun 2020 16:57:11 +0200
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
Message-ID: <20200615145711.GA24927@kozik-lap>
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de>
 <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
 <20200615131006.GR4447@sirena.org.uk>
 <CA+h21hpusy=zx8AuUqk_4zShtst8QeNJxCPT4dMGh0jhm5uZng@mail.gmail.com>
 <20200615134119.GB3321@kozik-lap>
 <CA+h21hp29i=AdZB_fBQ4mwAh=3Oovopwz3ruzzJqiKpRpZYzhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+h21hp29i=AdZB_fBQ4mwAh=3Oovopwz3ruzzJqiKpRpZYzhg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 05:23:28PM +0300, Vladimir Oltean wrote:
> On Mon, 15 Jun 2020 at 16:41, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >
> > On Mon, Jun 15, 2020 at 04:12:28PM +0300, Vladimir Oltean wrote:
> > > On Mon, 15 Jun 2020 at 16:10, Mark Brown <broonie@kernel.org> wrote:
> > >
> > > >
> > > > It's a bit unusual to need to actually free the IRQ over suspend -
> > > > what's driving that requirement here?
> > >
> > > clk_disable_unprepare(dspi->clk); is driving the requirement - same as
> > > in dspi_remove case, the module will fault when its registers are
> > > accessed without a clock.
> >
> > In few cases when I have shared interrupt in different drivers, they
> > were just disabling it during suspend. Why it has to be freed?
> >
> > Best regards,
> > Krzysztof
> >
> 
> Not saying it _has_ to be freed, just to be prevented from running
> concurrently with us disabling the clock.
> But if we can get away in dspi_suspend with just disable_irq, can't we
> also get away in dspi_remove with just devm_free_irq?

One reason why they have to be different could be following scenario:
1. Device could be unbound any time and disabling IRQ in remove() would
   effectively disable the IRQ also for other devices using this shared
   line. First disable_irq() really disables it, the latter just
   increases the counter.
2. However during system suspend, it is expected that all drivers in
   their suspend (and later resume) callbacks will do the same - disable
   the shared IRQ line. And finally the system disables interrupts
   globally so the line will be balanced.

Freeing IRQ solves the case #1 without causing any imbalance between
enables/disables or requests/frees.  Disabling IRQ solves the #2, also
without any imbalance.

Best regards,
Krzysztof



