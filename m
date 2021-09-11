Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34E44074BC
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 04:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbhIKCup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 22:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhIKCup (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 22:50:45 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DE4C061574;
        Fri, 10 Sep 2021 19:49:33 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id r3so6346996ljc.4;
        Fri, 10 Sep 2021 19:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jUnTFTRMGBYjF/mbT5UWmnePXXWLexnSKuOC4l7N77Y=;
        b=ifWsTlUp5NvP7Zk+Hk0YnROYSPPE9lwSXm+tiEaNNi54+FGC5NJXZhQFUpU1nHuCZm
         Xexp5BII09ScUf/o1qilGAxRjCO9hivw5UvyrZIYUMg00jB6IUHCW+fN/BRoYjUaPJfJ
         XqfjxgQMut41FUxX0URvUPYMI1Tb3dhnxurY2KzpKK6jkgvtXfG0+Of9F2uaoQZIzUMJ
         RYsSHypcLvvJ9g75hz8mKX1iGeS9kyQB0WAq0/ufT3PQOx+FX8q72pjY7b3EH6wdTslM
         Vj1ly8NqrKsv8EhwpQ2k7ys5F029yU3AaImxwBO+7DATvE4CH6cqqz1pwGiJnOCcU3ZN
         rn0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jUnTFTRMGBYjF/mbT5UWmnePXXWLexnSKuOC4l7N77Y=;
        b=TKGGQFMn4eVG3fv/CdDEuzywGwyaBMQpYzFsjkKvR4kjMWESqqXkpVPAE57djZ9M8r
         eRmfChaFM9Nw0Tk74Dg1s8yKihF0HBbPx5MCbk3BWbI461rgl7SrJx9EBXlgRq4BBXQA
         5t6SFKBO+w2h8THkU76Wwb3uYZB2aTxUPFUqOcmzCRoLAB9FzKXJ/QyhKqV6RMVzvmWA
         XSmflAzeFZK0oqLrXfH3eVg9qmPy1ab2Hi6VJF8IfTdciQ26e8jYfaK0ZQoiaaOp2g9+
         JhTsAT4aZG248mSM3Sz4aUwl2YMFYDdk5ogdaAWdAFBmCUXCnmvdluG1UJ+jyU4hjpQi
         UTAA==
X-Gm-Message-State: AOAM5333c3bOkHYBqJFsCl8On+PFRNQAXUq7CZJ4CZrblCPANrfPo3f+
        X/2iYGQG1u49rydkfp3xAgAmYWUaOXaczgExkw4=
X-Google-Smtp-Source: ABdhPJy+5BpUT6N7sD4/MBdEKUUrw0IIZJf8dJ1I+3L2hlGnpn1BRMxMcNliyh7E53qZqbHedHRUh96wIys447yxgS4=
X-Received: by 2002:a2e:7c1a:: with SMTP id x26mr582513ljc.375.1631328571880;
 Fri, 10 Sep 2021 19:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200624195811.435857-1-maz@kernel.org> <20200624195811.435857-8-maz@kernel.org>
 <CAMuHMdV+Ev47K5NO8XHsanSq5YRMCHn2gWAQyV-q2LpJVy9HiQ@mail.gmail.com>
 <875yv8d91b.wl-maz@kernel.org> <CAMuHMdV+ydPaXbGf1_O0S-juaPWk1gwBUOK+GeLZukZeoqtMGQ@mail.gmail.com>
In-Reply-To: <CAMuHMdV+ydPaXbGf1_O0S-juaPWk1gwBUOK+GeLZukZeoqtMGQ@mail.gmail.com>
From:   Magnus Damm <magnus.damm@gmail.com>
Date:   Sat, 11 Sep 2021 11:49:20 +0900
Message-ID: <CANqRtoTqV8sOpL=hdxeZ03tqr+5oeMcfwz+9ERqXv+hze_6Fsw@mail.gmail.com>
Subject: Re: [PATCH v2 07/17] irqchip/gic: Atomically update affinity
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Android Kernel Team <kernel-team@android.com>,
        stable <stable@vger.kernel.org>,
        Magnus Damm <damm+renesas@opensource.se>,
        =?UTF-8?Q?Niklas_S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Geert, Mark, RMK, everyone,

Thanks for your efforts. Let me just chime in with a few details and a question.

On Fri, Sep 10, 2021 at 10:19 PM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, Sep 10, 2021 at 12:23 PM Marc Zyngier <maz@kernel.org> wrote:
> > On Thu, 09 Sep 2021 16:22:01 +0100,
> > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>     GIC: enabling workaround for broken byte access

Indeed, byte access is unsupported according to the EMEV2 documentation.

The EMEV2 documentation R19UH0036EJ0600 Chapter 7 Interrupt Control on
page 97 says:
"Interrupt registers can be accessed via the APB bus, in 32-bit units"
"For details about register functions, see ARM Generic Interrupt
Controller Architecture Specification Architecture version 1.0"
The file  "R19UH0036EJ0600_1Chip.pdf" is the 6th edition version
published in 2010 and is not marked as confidential.

From my basic research, "ARM Generic Interrupt Controller Architecture
Specification Architecture version 1.0" is documented in ARM IHI 0048A
from 2008 (Non-Confidential) which contains:
"All GIC registers are 32-bit wide." and "All registers support 32-bit
word access..."
"In addition, the following registers support byte accesses:"
"ICDIPR"
"ICDIPTR"

So the GICv1 documentation says byte access is partially supported
however EMEV2 documentation says 32-bit access is required.

> > +               .compatible     = "arm,pl390",
> > +               .init           = gic_enable_rmw_access,
> > +       },

May I ask about a clarification about the EMEV2 DTS and DT binding
documentation in:
arch/arm/boot/dts/emev2.dts
Documentation/devicetree/bindings/interrupt-controller/arm,gic.yaml

On EMEV2 the DT compatible string currently seems to be the rather
generic "arm,pl390". In the DT binding documentation GICv1 is listed
in an example as "arm,cortex-a9-gic". Is there any reason for not
using the GICv1 compatible string (and 32-bit access) for EMEV2? Just
curious.

Cheers,

/ magnus
