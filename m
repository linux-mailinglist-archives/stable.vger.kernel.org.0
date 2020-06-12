Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB591F753B
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 10:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgFLIXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 04:23:33 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39807 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgFLIXd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 04:23:33 -0400
Received: by mail-ed1-f67.google.com with SMTP id g1so5812887edv.6;
        Fri, 12 Jun 2020 01:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W7kjCf2/NPWzaAeHmAsGNvR+U/IDoRneEJh+pNJVKTI=;
        b=rRwlEsGEidwnhVrlJr8ciBVdEz7z7zNlRfks+dZPjljVIj6O+5mwG4HGk6HuFuvOqx
         EZtiPFi3tEGm3372WvMTYupVxFk5mY49qzSlM1Oc9HRwvmJfjBHlksK0ahP3diQqql+v
         3BKxwhCkW1M9ZDR/F3zMiGHLk0Z19gwafaB5JwttznLTLc2zdEexuLsajTGgw/kvqIHX
         57MUJQ0Mu8t48E7zxv74uIjyFGcaU0WGqNjRnM+sAFOZUzg5h+9aBWqc73y/gmHKh2ar
         A1lRn49p5ysqqwmVPtaGksPjMuPyzmdBl6asnDfeC6duCYuMqFynUcouFeyRbdifaEPy
         wgGQ==
X-Gm-Message-State: AOAM5305kgABOa7HxU36CLhnCyCoSNgvRpFGr4hkSygp0t72xV/Z1I+j
        OXt5P0DwpYGU25ZKtE6LzJM=
X-Google-Smtp-Source: ABdhPJxxAoLFRIexOIimzunGIXKEGJy9vuUQgzNABANWPlkiFc4Cg/PTfeBSdakQzbTCe25y53Zq9g==
X-Received: by 2002:a50:f1d9:: with SMTP id y25mr10284528edl.292.1591950211017;
        Fri, 12 Jun 2020 01:23:31 -0700 (PDT)
Received: from pi3 ([194.230.155.184])
        by smtp.googlemail.com with ESMTPSA id g22sm2797843edj.63.2020.06.12.01.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 01:23:29 -0700 (PDT)
Date:   Fri, 12 Jun 2020 10:23:27 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Fugang Duan <B38611@freescale.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Gao Pan <b54642@freescale.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Wolfram Sang <wsa@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: imx: Fix external abort on early interrupt
Message-ID: <20200612082327.GA25893@pi3>
References: <1591796802-23504-1-git-send-email-krzk@kernel.org>
 <20200612055114.alhm2uakoze6epvf@pengutronix.de>
 <20200612073815.GA25803@pi3>
 <20200612080240.73xkiu2esgg6nbp3@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200612080240.73xkiu2esgg6nbp3@pengutronix.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 12, 2020 at 10:02:40AM +0200, Oleksij Rempel wrote:
> On Fri, Jun 12, 2020 at 09:38:15AM +0200, Krzysztof Kozlowski wrote:
> > On Fri, Jun 12, 2020 at 07:51:14AM +0200, Oleksij Rempel wrote:
> > > Hi Krzysztof,
> > > 
> > > thank you for your patch.
> > > 
> > > On Wed, Jun 10, 2020 at 03:46:42PM +0200, Krzysztof Kozlowski wrote:
> > > > If interrupt comes early (could be triggered with CONFIG_DEBUG_SHIRQ),
> > > > the i2c_imx_isr() will access registers before the I2C hardware is
> > > > initialized.  This leads to external abort on non-linefetch on Toradex
> > > > Colibri VF50 module (with Vybrid VF5xx):
> > > > 
> > > >     Unhandled fault: external abort on non-linefetch (0x1008) at 0x8882d003
> > > >     Internal error: : 1008 [#1] ARM
> > > >     Modules linked in:
> > > >     CPU: 0 PID: 1 Comm: swapper Not tainted 5.7.0 #607
> > > >     Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> > > >       (i2c_imx_isr) from [<8017009c>] (free_irq+0x25c/0x3b0)
> > > >       (free_irq) from [<805844ec>] (release_nodes+0x178/0x284)
> > > >       (release_nodes) from [<80580030>] (really_probe+0x10c/0x348)
> > > >       (really_probe) from [<80580380>] (driver_probe_device+0x60/0x170)
> > > >       (driver_probe_device) from [<80580630>] (device_driver_attach+0x58/0x60)
> > > >       (device_driver_attach) from [<805806bc>] (__driver_attach+0x84/0xc0)
> > > >       (__driver_attach) from [<8057e228>] (bus_for_each_dev+0x68/0xb4)
> > > >       (bus_for_each_dev) from [<8057f3ec>] (bus_add_driver+0x144/0x1ec)
> > > >       (bus_add_driver) from [<80581320>] (driver_register+0x78/0x110)
> > > >       (driver_register) from [<8010213c>] (do_one_initcall+0xa8/0x2f4)
> > > >       (do_one_initcall) from [<80c0100c>] (kernel_init_freeable+0x178/0x1dc)
> > > >       (kernel_init_freeable) from [<80807048>] (kernel_init+0x8/0x110)
> > > >       (kernel_init) from [<80100114>] (ret_from_fork+0x14/0x20)
> > > > 
> > > > Additionally, the i2c_imx_isr() could wake up the wait queue
> > > > (imx_i2c_struct->queue) before its initialization happens.
> > > > 
> > > > Fixes: 1c4b6c3bcf30 ("i2c: imx: implement bus recovery")
> > > > Cc: <stable@vger.kernel.org>
> > > > Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> > > 
> > > 
> > > I assume register access is aborted, because the IP core clock is not
> > > enabled. In this case we have bigger problem then just probe.
> > 
> > If by IP core clock you mean the clock which driver is getting, then
> > answer is no. This clock is enabled.
> > 
> > > Since this driver support runtime power management, the clock will be
> > > disabled as soon as transfer is done. It means, on shared interrupt, we
> > > will get in trouble even if there is no active transfer.
> > 
> > The driver's runtime PM plays only with this one clock, so it seems
> > you meant i2c_imx->clk. It is not this problem.
> > 
> > > 
> > > So, probably the only way to fix it, is to check in i2c_imx_isr() if the
> > > HW is expected to be active and register access should be save.
> > 
> > Checking in every interrupt whether the interrupt should be serviced
> > based on some SW flag because HW might be disabled? That looks unusual,
> > like a hack.
> > 
> > No, the interrupt should be registered when the driver and some other
> > pieces of HW are ready to service it.
> 
> OK.
> please make sure, irq is probed before calling
> i2c_add_numbered_adapter(). This will trigger deferred probing of
> slave devices. Since the irq handler will be added later, tx completion
> of some requests will be lost or fail.

Right. I'll move the devm_request_irq().

Best regards,
Krzysztof

