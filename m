Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708ED1E239A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 16:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgEZOEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 10:04:24 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41114 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbgEZOEY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 10:04:24 -0400
Received: by mail-ot1-f67.google.com with SMTP id 63so16341701oto.8;
        Tue, 26 May 2020 07:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Ierdu4jhjBArg4KAhxK2ET/zYux67GkijyWUlcmSlg=;
        b=t8bBqFbmYQ/VnfvQ16TPgsta/UMd6BjOJxfiQrsjr3GJRIWknMTExOA/9FcNxwwyi2
         dSFJdQUgRzyqK2hbe2Br6lXNql3X+ZUkGsQFv5SLN0yTRF6QOcK26If3t7JE9BQRuQSz
         VbslbKXA6aNYer+m9wQmF+sygHMIt/y15Orl1RuNMMs8Jlr78evQq2bzJK73hNuQhlYr
         oRc3KfFRowe2MPP1yAhy3QIRbRpyFnY+5E3AklSlfR6/cIHbQRU9KshMsOY8A7VufOVY
         VPMRImQ8FelqfWBQDg2Flujq/+ro/9bHEA1rh9GS0c2jwfqvVuC+Odf41zb1waz59CO5
         9Wlw==
X-Gm-Message-State: AOAM5310RoIOchT3Ga7eOFlxXmV5vEkyyz4MMTVmZgeBwE+o11Kpmejc
        k6tuYWBUDaWLkIks4areqxk44OHRjd6dMCbcnCU=
X-Google-Smtp-Source: ABdhPJyUNtHDNcsWTXkodpXr8omxt8fKKmdXPMuKjXr10pz49QCMDOCfVptyEHRHzvYaFzWQrAougJhfu1ijiVuoj4E=
X-Received: by 2002:a9d:6c0f:: with SMTP id f15mr934672otq.118.1590501863497;
 Tue, 26 May 2020 07:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200515093613.18691-1-ardb@kernel.org> <CAJZ5v0guHdbZTsU5e7KDAHDy9Gnh67JwtSSCeDaK8mUwAk1d3g@mail.gmail.com>
 <CAMj1kXFVYOoX=pe9uVY-j_o8YhhE_Fef6q6jc8S9nzBLYSBb=g@mail.gmail.com>
In-Reply-To: <CAMj1kXFVYOoX=pe9uVY-j_o8YhhE_Fef6q6jc8S9nzBLYSBb=g@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 26 May 2020 16:04:10 +0200
Message-ID: <CAJZ5v0i0LbDjATGGN-+Xu_ztyrkCL5EXqwjdYDLwpnALiOoBtA@mail.gmail.com>
Subject: Re: [PATCH] ACPI: GED: add support for _Exx / _Lxx handler methods
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 1:12 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Hello Rafael,
>
> I spotted an issue with this patch. Please see below.
>
>
> On Fri, 15 May 2020 at 18:32, Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Fri, May 15, 2020 at 11:37 AM Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > Per the ACPI spec, interrupts in the range [0, 255] may be handled
> > > in AML using individual methods whose naming is based on the format
> > > _Exx or _Lxx, where xx is the hex representation of the interrupt
> > > index.
> > >
> > > Add support for this missing feature to our ACPI GED driver.
> > >
> > > Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > > Cc: Len Brown <lenb@kernel.org>
> > > Cc: linux-acpi@vger.kernel.org
> > > Cc: <stable@vger.kernel.org> # v4.9+
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > >  drivers/acpi/evged.c | 22 +++++++++++++++++---
> > >  1 file changed, 19 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/drivers/acpi/evged.c b/drivers/acpi/evged.c
> > > index aba0d0027586..6d7a522952bf 100644
> > > --- a/drivers/acpi/evged.c
> > > +++ b/drivers/acpi/evged.c
> > > @@ -79,6 +79,8 @@ static acpi_status acpi_ged_request_interrupt(struct acpi_resource *ares,
> > >         struct resource r;
> > >         struct acpi_resource_irq *p = &ares->data.irq;
> > >         struct acpi_resource_extended_irq *pext = &ares->data.extended_irq;
> > > +       char ev_name[5];
> > > +       u8 trigger;
> > >
> > >         if (ares->type == ACPI_RESOURCE_TYPE_END_TAG)
> > >                 return AE_OK;
> > > @@ -87,14 +89,28 @@ static acpi_status acpi_ged_request_interrupt(struct acpi_resource *ares,
> > >                 dev_err(dev, "unable to parse IRQ resource\n");
> > >                 return AE_ERROR;
> > >         }
> > > -       if (ares->type == ACPI_RESOURCE_TYPE_IRQ)
> > > +       if (ares->type == ACPI_RESOURCE_TYPE_IRQ) {
> > >                 gsi = p->interrupts[0];
> > > -       else
> > > +               trigger = p->triggering;
> > > +       } else {
> > >                 gsi = pext->interrupts[0];
> > > +               trigger = p->triggering;
>
> This should be 'pext->triggering' instead.
>
> In practice, it doesn't matter, since p and pext point to the same
> union, and the 'triggering' field happens to be at the same offset.
> But it should still be fixed, of course.
>
> Would you prefer a followup patch? Or can you fix it locally?

A followup, please.
