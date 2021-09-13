Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC53C408611
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 10:05:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237722AbhIMIGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 04:06:39 -0400
Received: from mail-vs1-f47.google.com ([209.85.217.47]:37610 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237797AbhIMIGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 04:06:38 -0400
Received: by mail-vs1-f47.google.com with SMTP id i23so7629360vsj.4;
        Mon, 13 Sep 2021 01:05:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hIy/WF41WnhInRxQvOeLA91NgtT/ad5oPS0o2VKCwNg=;
        b=H1wPdid9exSg992pPXhiMALn/wP/WluGxrpodaX1dXaLk5agS9mbY2yNT/LkDIvVP/
         UZq0eLqXKW7eiJTLtNyHs2ag19/bQH+yVAxbR29EcWipIPoPzZG9ElYun+7fXCnXnwX5
         IGPlyOI1hteTd1Pdfrzj0zi1d8CVrpkEIIcydKhybo/8re/g1YBa1SZegn9cDo3pcGb6
         AVzZZFG749rmuw0sgd3vELdS7+mOoNgCQA0dPXnvsC6y1CtZEhCnYgi235Wka8tiOG7a
         VEgvxC3ecjIHdzth723jUqYenqYkfyv1FM9ow6wP+cSm5Yn66Sb0ZpZfy1gQyjdErZxb
         Rsqg==
X-Gm-Message-State: AOAM530VG9N7DxeRHM1vO5J8LwqJ9TG+eb6JgvYQbfSapGTk4gsb3BEi
        pWWWWr86mWYNoTuhl4l6qTo2eWsii/w249BGYUiJYdoi7/w=
X-Google-Smtp-Source: ABdhPJy5qS7cAHC3Wj9WuuKOmYXH4sq8/3ktX7gWNSl8zk/qKzaCAAZqM9h3ouNfCut0fUdqY/dAAiCGCBBDbPtKIvo=
X-Received: by 2002:a05:6102:3112:: with SMTP id e18mr2487715vsh.50.1631520322815;
 Mon, 13 Sep 2021 01:05:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200624195811.435857-1-maz@kernel.org> <20200624195811.435857-8-maz@kernel.org>
 <CAMuHMdV+Ev47K5NO8XHsanSq5YRMCHn2gWAQyV-q2LpJVy9HiQ@mail.gmail.com>
 <875yv8d91b.wl-maz@kernel.org> <CAMuHMdV+ydPaXbGf1_O0S-juaPWk1gwBUOK+GeLZukZeoqtMGQ@mail.gmail.com>
 <CANqRtoTqV8sOpL=hdxeZ03tqr+5oeMcfwz+9ERqXv+hze_6Fsw@mail.gmail.com>
 <874kaqdi2z.wl-maz@kernel.org> <CANqRtoTa8g2sw_DoD8+34HR0mcHc_tOWt+4R9KzDT2Eu3d7TTg@mail.gmail.com>
In-Reply-To: <CANqRtoTa8g2sw_DoD8+34HR0mcHc_tOWt+4R9KzDT2Eu3d7TTg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 13 Sep 2021 10:05:11 +0200
Message-ID: <CAMuHMdX3Vf8Mxuz3=Aoi1hwMS7BtyYCH178QvVS-GAHDpeMvxg@mail.gmail.com>
Subject: Re: [PATCH v2 07/17] irqchip/gic: Atomically update affinity
To:     Magnus Damm <magnus.damm@gmail.com>
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

Hi Magnus,

On Sun, Sep 12, 2021 at 7:40 AM Magnus Damm <magnus.damm@gmail.com> wrote:
> On Sun, Sep 12, 2021 at 4:32 AM Marc Zyngier <maz@kernel.org> wrote:
> > On Sat, 11 Sep 2021 03:49:20 +0100,
> > Magnus Damm <magnus.damm@gmail.com> wrote:
> > > On Fri, Sep 10, 2021 at 10:19 PM Geert Uytterhoeven
> > > <geert@linux-m68k.org> wrote:
> > > > On Fri, Sep 10, 2021 at 12:23 PM Marc Zyngier <maz@kernel.org> wrote:
> > > > > On Thu, 09 Sep 2021 16:22:01 +0100,
> > > > > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > >     GIC: enabling workaround for broken byte access
> > >
> > > Indeed, byte access is unsupported according to the EMEV2 documentation.
> > >
> > > The EMEV2 documentation R19UH0036EJ0600 Chapter 7 Interrupt Control on
> > > page 97 says:
> > > "Interrupt registers can be accessed via the APB bus, in 32-bit units"
> > > "For details about register functions, see ARM Generic Interrupt
> > > Controller Architecture Specification Architecture version 1.0"
> > > The file  "R19UH0036EJ0600_1Chip.pdf" is the 6th edition version
> > > published in 2010 and is not marked as confidential.
> >
> > This is as bad as it gets. Do you know if any other Renesas platform
> > is affected by the same issue?
>
> Next time we have a beer together I would be happy to show you some
> legacy interrupt controller code. =)
>
> EMEV2 and the Emma Mobile product line came from the NEC Electronics
> side that got merged into Renesas Electronics in 2010. Historically
> NEC Electronics mainly used MIPS I've been told, and the Emma Mobile
> SoCs were one of the earlier Cortex-A9 adopters. That might have
> something to do with the rather loose interpretation of the spec.

Indeed.  I used to work on products using EMMA1 and EMMA2, and they
were MIPS-based (vr4120A for EMMA2, IIRC).  Later variants (EMMA2H
and EMMA3?) did include a small ARM core for standby control.

> Renesas SoCs from a similar era:
> AP4 (sh7372) AP4EVB (Cortex-A8 + INTCA/INTCS)

This is no longer supported upstream (and not affected, as no GIC).

> R-Mobile A1 (r8a7740) Armadillo-800-EVA (Cortex-A9 + INTCA/INTCS)

R-Mobile A1 has GIC (PL390), too, and is not affected.

> R-Car M1A (r8a7778) Bock-W (Cortex-A9 + GIC)
> R-Car H1 (r8a7779) Marzen (4 x Cortex-A9 + GIC)
> Emma Mobile EMEV2 KZM9D (2 x Cortex-A9 + GIC)
> SH-Mobile AG5 (sh73a0) KZM9G (2 x Cortex-A9 + GIC)

All of these (except for EMEV2) are fine, too.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
