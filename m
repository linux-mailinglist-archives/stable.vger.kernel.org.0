Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CFB1F9097
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 09:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgFOHvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 03:51:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50738 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729161AbgFOHvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 03:51:13 -0400
Received: by mail-wm1-f66.google.com with SMTP id l17so13600236wmj.0;
        Mon, 15 Jun 2020 00:51:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+HRGqyB5oqaA4VgjPNyb3KQ62e/coD1Hg4szCBEPxow=;
        b=gdU7elIPsixG+TZ3GyDUXDJEKLlaxdrRI7ecDQHi2DFVixXRPo4RAHAMJcddNNmrqy
         6JKkfCn1IljII49Ab2/IGcgbokDo2F6LrcioozF0C41TG5Fz9xNCo7SiOjqKHVuFan3b
         kg1no+JvNFXE0BC3C6sXuK/sQrXNfNfLRmU4p/sURlpmshIpXe+/2XuTZD54ZUHLoU+E
         LsCb8BTw1ES0oPcjMeX+iMH12Ai6S0r5RXd7sNif1i0soGbKukSdeacb6n6RmTuBK9ml
         GfgE+zR9DP771DIRvpdEzecoJjlKAXi2527oOE5y7tUvzw27qxioEWWJVu46ZySUlT6P
         URkw==
X-Gm-Message-State: AOAM533P90UD7SlDvsSHL6NZqxV5DYlgYuMqKNgy0S6k+z4JEnd7GZfJ
        DNxA8RhuRMJA1aHrXMMVXiHcZsi8
X-Google-Smtp-Source: ABdhPJybYmPkJSlRnaMOuMktCVCC4yXe4QTkEyvxsVBtStC2ueb6/Stxp+dCP3g7zIfQ3UXBa1NUSQ==
X-Received: by 2002:a1c:a74d:: with SMTP id q74mr11611364wme.177.1592207471716;
        Mon, 15 Jun 2020 00:51:11 -0700 (PDT)
Received: from kozik-lap ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id g3sm25678681wrb.46.2020.06.15.00.51.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Jun 2020 00:51:11 -0700 (PDT)
Date:   Mon, 15 Jun 2020 09:51:09 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] spi: spi-fsl-dspi: Fix external abort on interrupt
 in exit paths
Message-ID: <20200615075109.GA22427@kozik-lap>
References: <1592132154-20175-1-git-send-email-krzk@kernel.org>
 <CA+h21hpsmG+xUjWgaNcSojxeWYm4bcbMsn6_hmZrJ0A3zfVEag@mail.gmail.com>
 <20200615071540.GB20941@kozik-lap>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200615071540.GB20941@kozik-lap>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 09:15:40AM +0200, Krzysztof Kozlowski wrote:
> On Sun, Jun 14, 2020 at 06:48:04PM +0300, Vladimir Oltean wrote:
> > On Sun, 14 Jun 2020 at 13:57, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > >
> > > If interrupt comes late, during probe error path or device remove (could
> > > be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
> > > dspi_interrupt() will access registers with the clock being disabled.  This
> > > leads to external abort on non-linefetch on Toradex Colibri VF50 module
> > > (with Vybrid VF5xx):
> > >
> > >     $ echo 4002d000.spi > /sys/devices/platform/soc/40000000.bus/4002d000.spi/driver/unbind
> > >
> > >     Unhandled fault: external abort on non-linefetch (0x1008) at 0x8887f02c
> > >     Internal error: : 1008 [#1] ARM
> > >     CPU: 0 PID: 136 Comm: sh Not tainted 5.7.0-next-20200610-00009-g5c913fa0f9c5-dirty #74
> > >     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> > >       (regmap_mmio_read32le) from [<8061885c>] (regmap_mmio_read+0x48/0x68)
> > >       (regmap_mmio_read) from [<8060e3b8>] (_regmap_bus_reg_read+0x24/0x28)
> > >       (_regmap_bus_reg_read) from [<80611c50>] (_regmap_read+0x70/0x1c0)
> > >       (_regmap_read) from [<80611dec>] (regmap_read+0x4c/0x6c)
> > >       (regmap_read) from [<80678ca0>] (dspi_interrupt+0x3c/0xa8)
> > >       (dspi_interrupt) from [<8017acec>] (free_irq+0x26c/0x3cc)
> > >       (free_irq) from [<8017dcec>] (devm_irq_release+0x1c/0x20)
> > >       (devm_irq_release) from [<805f98ec>] (release_nodes+0x1e4/0x298)
> > >       (release_nodes) from [<805f9ac8>] (devres_release_all+0x40/0x60)
> > >       (devres_release_all) from [<805f5134>] (device_release_driver_internal+0x108/0x1ac)
> > >       (device_release_driver_internal) from [<805f521c>] (device_driver_detach+0x20/0x24)
> > >
> > > The resource-managed framework should not be used for interrupt handling,
> > > because the resource will be released too late - after disabling clocks.
> > > The interrupt handler is not prepared for such case.
> > >
> > > Fixes: 349ad66c0ab0 ("spi:Add Freescale DSPI driver for Vybrid VF610 platform")
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > >
> > > ---
> > 
> > I don't buy this argument that "the resource-managed framework should
> > not be used for interrupt handling". What is it there for, then?
> 
> It was created long time ago for memory allocations and since then
> people ported to all other possibilities and used in drivers.  Just
> because you can do something, does not necessarily mean that you
> should...
> 
> > Could you just call disable_irq before clk_disable_unprepare instead
> > of this massive rework?
> 
> This massive rework is 9 insertions and 4 deletions, indeed I made
> impressive, huge commit with significant impact. disable_irq() could work
> as well so if this is preferred, no problem from my side.

disable_irq() should fix real world case but won't fix DEBUG_SHIRQ.
I'll rework it as well but then we go to bigger change again.

Best regards,
Krzysztof

