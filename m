Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9824A3A9D
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 22:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiA3V6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 16:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiA3V6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 16:58:54 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A721AC061714;
        Sun, 30 Jan 2022 13:58:54 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id s1so10072793ilj.7;
        Sun, 30 Jan 2022 13:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2WzkOWbIGCxdnVfXxbYeaOq1kkhUVPgWWkMq9T4jHSE=;
        b=bvWeAhe+cBYkOf8yfESB8c/eVFNJtaz5kGSi0Obb7CJpqjJPQsAf3Hm4uoD9OE7IyB
         /5AIwx60UF9dAHw5Nt7hRhionD80uqShGX2FTE5oikDnODb+eiLIxZnlJEYWkv69IhaH
         WCXyqyPV9qxsH87vTvbr2XZvEvS58ShPSoFDDSwmvCi6geLTP/cXJGcmyRa/eNVPvvjC
         nbFBb3W2Psi2CyrC+J0Ps4WmGwUzFuAWKJlRe9w/0RliAk9WPm7/P87aC14sNjFubkT1
         JPptaX0e4fmcdQBIxDJybUWpYlQvC3tiFcDGYfeANiTUyQcECPChvs/rTzEhvm+ALMN3
         K63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2WzkOWbIGCxdnVfXxbYeaOq1kkhUVPgWWkMq9T4jHSE=;
        b=UsLMPLk4XFonEYTDE4i7S5JQYfXCPqI34TuedepdI1/triAuZShGTNQxh+KtvJJIRJ
         HZ9Tsm9J0cilpwWPgh4IxGP0xI5UsSPQ/qaMra4apy09AvB5VTyZjs64W+XliQtOOohS
         fjbjk4Oo1BoUu0wfWjtYsNZvTzk33Uq5Ua+fIa9wTKx7NFjB8Mi8jS1J7d9HrTJKoP5e
         jedVaGp+nO+jBVqwQDpMkRk/mGEw82lTqv8DgIBiFKDdI11cx3UpYzuL+bzDgatYR2Q2
         CIl+gDSY8Ue0a75x3rEnXLX/lc6EHZFDO4FNYV7RkjKFMjPJB83p9tLFb+A5MW2H0awK
         B7jg==
X-Gm-Message-State: AOAM533MnQTFwNze2uK336Jq7lpeCEuO5kof/2iBSyvKYv7UVOObtacs
        ao2CWw/GU/DbJA6VZIgeMXLRfvZPqXbr7MonfPI=
X-Google-Smtp-Source: ABdhPJzdNxGsjYLUnKAgvNscB7weXb0Tpcw2mQrzlxcr5RkfUXLhB6PciOFtfhw/stH614ok3qe9r0CiU01gh1SZm0E=
X-Received: by 2002:a05:6e02:1244:: with SMTP id j4mr11187403ilq.28.1643579933258;
 Sun, 30 Jan 2022 13:58:53 -0800 (PST)
MIME-Version: 1.0
References: <20220126205214.2149936-1-jannh@google.com> <CA+fCnZe_p+JwUWwumgGm185vWSdAK_z-UFDp7-HWKANB4YjA=g@mail.gmail.com>
 <CAG48ez0pke5fqEuWGecMAKLpsdVoW3JM3M-SkajHcq_dsrQ_4A@mail.gmail.com> <CA+fCnZdXpBHFN3u5exkbLkUsPaFVsbFi=evsPd3uMMfV=tKAeg@mail.gmail.com>
In-Reply-To: <CA+fCnZdXpBHFN3u5exkbLkUsPaFVsbFi=evsPd3uMMfV=tKAeg@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@gmail.com>
Date:   Sun, 30 Jan 2022 22:58:42 +0100
Message-ID: <CA+fCnZc4kavuHbGXAbzQJSLG=f9Oc--O-H=OT_xkKb0AooyyAQ@mail.gmail.com>
Subject: Re: [PATCH] usb: raw-gadget: fix handling of dual-direction-capable endpoints
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Felipe Balbi <balbi@kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 26, 2022 at 11:37 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
>
> On Wed, Jan 26, 2022 at 11:31 PM Jann Horn <jannh@google.com> wrote:
> >
> > On Wed, Jan 26, 2022 at 11:12 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
> > > On Wed, Jan 26, 2022 at 9:52 PM Jann Horn <jannh@google.com> wrote:
> > > >
> > > > Under dummy_hcd, every available endpoint is *either* IN or OUT capable.
> > > > But with some real hardware, there are endpoints that support both IN and
> > > > OUT. In particular, the PLX 2380 has four available endpoints that each
> > > > support both IN and OUT.
> > > >
> > > > raw-gadget currently gets confused and thinks that any endpoint that is
> > > > usable as an IN endpoint can never be used as an OUT endpoint.
> > > >
> > > > Fix it by looking at the direction in the configured endpoint descriptor
> > > > instead of looking at the hardware capabilities.
> > > >
> > > > With this change, I can use the PLX 2380 with raw-gadget.
> > > >
> > > > Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
> > > > Signed-off-by: Jann Horn <jannh@google.com>
> > > > ---
> > > >  drivers/usb/gadget/legacy/raw_gadget.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/usb/gadget/legacy/raw_gadget.c b/drivers/usb/gadget/legacy/raw_gadget.c
> > > > index c5a2c734234a..d86c3a36441e 100644
> > > > --- a/drivers/usb/gadget/legacy/raw_gadget.c
> > > > +++ b/drivers/usb/gadget/legacy/raw_gadget.c
> > > > @@ -1004,7 +1004,7 @@ static int raw_process_ep_io(struct raw_dev *dev, struct usb_raw_ep_io *io,
> > > >                 ret = -EBUSY;
> > > >                 goto out_unlock;
> > > >         }
> > > > -       if ((in && !ep->ep->caps.dir_in) || (!in && ep->ep->caps.dir_in)) {
> > > > +       if (in != usb_endpoint_dir_in(ep->ep->desc)) {
> > > >                 dev_dbg(&dev->gadget->dev, "fail, wrong direction\n");
> > > >                 ret = -EINVAL;
> > > >                 goto out_unlock;
> > > >
> > > > base-commit: 0280e3c58f92b2fe0e8fbbdf8d386449168de4a8
> > > > --
> > > > 2.35.0.rc0.227.g00780c9af4-goog
> > > >
>
> Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>
> Tested-by: Andrey Konovalov <andreyknvl@gmail.com>

Greg, could you PTAL and pick this up?

It also makes sense to include this fix into stable kernels.

Cc: <stable@vger.kernel.org>

Thanks!
