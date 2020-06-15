Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0AE1F988D
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgFON3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730135AbgFON33 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:29:29 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DD0C061A0E;
        Mon, 15 Jun 2020 06:29:27 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id t21so11493262edr.12;
        Mon, 15 Jun 2020 06:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3n3iifrtgR6E9IAv7YCfx/6Y4J2kmVU5EVk2pTsznw0=;
        b=gGW7yeWtA8oMDUL1dzcL69tgz1l3edifBui14SpedebaZIcAGPx+SFoh7OX1cksZ11
         ubxRPDvuQrJXxk3YE031pCtzOZRoOR+OfQXLLerGtsWvpyyUvBYyIuen90hFxseabdj3
         9xM1bR45EWFZYe7ZHK5B1pDbP8KDo9uW138VBxujud/7LHhHyoooQD8bBXqiX4Mt2pUe
         dDsENxfu8SDR9n/Tk3yF4IiD2exiHje1gGrEsmIkYS1SwT/wwHagec/Fw16OEWActooU
         fVw6SBNRfRIcq7gDqyoCze3dow4gqh/OFxztDrankON9Ny/DvDaSjjvhYanAAAb5UIfl
         Libw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3n3iifrtgR6E9IAv7YCfx/6Y4J2kmVU5EVk2pTsznw0=;
        b=NuX9u4FxAPvEm5LvkQS760IAiWwjapPcfQ7h+YSBzi6oU2yh9FL0JuQQf93p2TBSqQ
         YJ9dlF9enMKcqbY2me2xUHScvpSsco0diaAmlHXpSaNeXjezhRWVTgIVJsF7q5XSXNyf
         /iB067Imc1UirAxF9EK4ZkwvzYi3GjJIGcKUUjpBxNNbp+C3d1iXRNQ/IKd0rLXbeXBC
         AiBvMehpYcoDb/9QsLg5slxg/rnS8MjYQIsYPw3o0DSGeBiVi3Tc4DeFvGIj4j9qxdUZ
         Zameuwg1pJhzH//IJiFicAZue8VEWlNdQPidYxLzd099R5xe40FfKdIyXsRJcB8apFkN
         uf1A==
X-Gm-Message-State: AOAM530htd1/7hfhS3dmLXYoj2pJLBF3pR3KdWrV/QD0fvG2ldVOUqB4
        SJmRzmTeGKXba0AV1p5oi/86rvW+s///qrYnRjg=
X-Google-Smtp-Source: ABdhPJyd7casDi9grXgRAm6JAKIQQwZzv5PkN5WMqxqDrwzxO2WpDIV71Sv0ygftsfST2NrDtBc35Qv01KBQVzh9oUI=
X-Received: by 2002:a05:6402:362:: with SMTP id s2mr24158752edw.337.1592227766391;
 Mon, 15 Jun 2020 06:29:26 -0700 (PDT)
MIME-Version: 1.0
References: <1592208439-17594-1-git-send-email-krzk@kernel.org>
 <e1f0326c-8ae8-ffb3-aace-10433b0c78a6@pengutronix.de> <20200615123052.GO4447@sirena.org.uk>
 <CA+h21hqC7hAenifvRqbwss=Sr+dAu3H9Dx=UF0TS0WVbkzTj2Q@mail.gmail.com>
 <20200615131006.GR4447@sirena.org.uk> <CA+h21hpusy=zx8AuUqk_4zShtst8QeNJxCPT4dMGh0jhm5uZng@mail.gmail.com>
 <20200615132441.GS4447@sirena.org.uk>
In-Reply-To: <20200615132441.GS4447@sirena.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 15 Jun 2020 16:29:15 +0300
Message-ID: <CA+h21hpymKP5JGWZBNQTq4bZwJ6QZ3erACWV86nEaGsevZ++BA@mail.gmail.com>
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

On Mon, 15 Jun 2020 at 16:24, Mark Brown <broonie@kernel.org> wrote:
>
> On Mon, Jun 15, 2020 at 04:12:28PM +0300, Vladimir Oltean wrote:
> > On Mon, 15 Jun 2020 at 16:10, Mark Brown <broonie@kernel.org> wrote:
>
> > > It's a bit unusual to need to actually free the IRQ over suspend -
> > > what's driving that requirement here?
>
> > clk_disable_unprepare(dspi->clk); is driving the requirement - same as
> > in dspi_remove case, the module will fault when its registers are
> > accessed without a clock.
>
> I see - this could be fixed by having the interrupt handler bounce the
> clock on, there's a little overhead from that but hopefully not too
> much.  That should also help with the remove case I guess so long as the
> clock is registered before the interrupt is requested?

Doesn't this mean that we risk leaving the clock enabled during suspend?
Is there any function in the SPI core that quiesces any pending
transactions, and then stops the controller? I would have expected
spi_controller_suspend to do that, but I'm not sure (it doesn't look
like it).
