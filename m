Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1987BE0F
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 12:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfGaKKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 06:10:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36070 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfGaKKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 06:10:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so69084001wrs.3;
        Wed, 31 Jul 2019 03:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LaPBamwe8LNxxhMMnlugrgaLMOo+ivzahalIgxNO9YM=;
        b=bxRQm8RrZhN9Xc1mBZlynssfeaW+WRGEP49s2j9TdJXHIcYN/jJYvOaM4eBi2Z+mld
         xshXjZQIBLWU8FbKRdCz3BRyJhTLtHxi9gN8YkXmLTKbdgUNBkElQoprqE4YxSSg9gSV
         8f+a770AKt0wCxCQ2A4zN2G+/Uq+pNbzOxaUQ8XO4nDmyhmaD3dOYBPMsDyudvgdcmGa
         5+gUqg8tYq0b0Zoc5q1NsGzf04uiZWH73fYTOEHTBquDEmQJpvJ8lxr0ua85bphk51XE
         yomscBbywE0zB7hpyF22PeLyq3gRsal/BHCstMZwQuwcTfhG31jvatZiZQQGyb+yXy8C
         GxQg==
X-Gm-Message-State: APjAAAUFK5gWQDH/YFoIHfCbYXNzzbnJRAdIorppEJZptN3C2jT0e0Oi
        Hx9QCL07q5I56SxMMyIQeMWTsNbdXWd1MR3IjHM=
X-Google-Smtp-Source: APXvYqxnPqjf0pKDPP9iEC0wHGpvoacDZItJm4NNSvxzrLnaOqyc3Y99AHa0L6cIeVvp/HFF0mTSwr16a/6dnz8DtYg=
X-Received: by 2002:adf:cd81:: with SMTP id q1mr132338071wrj.16.1564567801751;
 Wed, 31 Jul 2019 03:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <1564563689-25863-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <CAMuHMdWhA2xxKKEmmobZDDKGnWNfO4xDb6m6gM16CCFX-1UyTQ@mail.gmail.com> <TYAPR01MB4544CFAACC4C81316CF0760DD8DF0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
In-Reply-To: <TYAPR01MB4544CFAACC4C81316CF0760DD8DF0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 31 Jul 2019 12:09:48 +0200
Message-ID: <CAMuHMdXyUEHAPYyBN=m6YwCS8129nD3q8Hi4Vh0fvpDwyHNWhw@mail.gmail.com>
Subject: Re: [PATCH] phy: renesas: rcar-gen3-usb2: Fix sysfs interface of "role"
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Pavel Machek <pavel@denx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Shimoda-san,

On Wed, Jul 31, 2019 at 11:58 AM Yoshihiro Shimoda
<yoshihiro.shimoda.uh@renesas.com> wrote:
> > From: Geert Uytterhoeven, Sent: Wednesday, July 31, 2019 6:27 PM
> > On Wed, Jul 31, 2019 at 11:04 AM Yoshihiro Shimoda
> > <yoshihiro.shimoda.uh@renesas.com> wrote:
> > > Since the role_store() uses strncmp(), it's possible to refer
> > > out-of-memory if the sysfs data size is smaller than strlen("host").
> > > This patch fixes it by using sysfs_streq() instead of strncmp().
> > >
> > > Reported-by: Pavel Machek <pavel@denx.de>
> > > Fixes: 9bb86777fb71 ("phy: rcar-gen3-usb2: add sysfs for usb role swap")
> > > Cc: <stable@vger.kernel.org> # v4.10+
> > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> >
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Thank you for your review!
>
> > > ---
> > >  Just a record. The role_store() doesn't need to check the count because
> > >  the sysfs_streq() checks the first argument is NULL or not.
> >
> > Is that wat you mean? sysfs_streq() doesn't seem to check for NULL pointers.
>
> Oops, sorry for unclear. I meant a NULL-terminated string, not NULL pointer.

OK.

> > Isn't the real reason that sysfs (kernfs) guarantees that the passed buffer
> > is NUL-terminated?
>
> I doesn't check in detail, but I assume so.

I have checked that recently, so it is OK.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
