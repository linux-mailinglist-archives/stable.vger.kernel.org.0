Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67166490120
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 06:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiAQFYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 00:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbiAQFYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 00:24:38 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A4EC061747
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 21:24:37 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id i8so9848147pgt.13
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 21:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ISpM5IrkTHsOLgNJIWuzTE0806bOg7B0Sd40UWe36MY=;
        b=mEmWRcI8rpsg6TVZzLXBc4yugerwYpj+1EEmNn/rJ8cJt+cMEF4GiUnb9KyxiUw+SW
         1aO3wa1dG9ddyVopK+OCJ+xArSKONuiiRSGgDkmALA1ArRsBK43EGeeaxLFpXOlgWcwp
         Y5ZwP0DkQ3D3dq/NaX3RjrKvPGzSr9GFTP6xLSBJ51dHQo2/RSBmexvFPgcsMuW6a2qV
         0svRY0qCbO6zl2v+JziGGW/GOWm4VVaBZvpwjP28z6hrOq8bjRuj4jYKOSbF9ZqNNDhl
         ZBLFWxERjjWjHnKOsoUx6Llwjjm/kgmrNOBdJj3gOxivQZU/186xYQO7jlfwZTiRIbO/
         R2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ISpM5IrkTHsOLgNJIWuzTE0806bOg7B0Sd40UWe36MY=;
        b=ICui7OpYVTfAECshPi8hNTMRNihWB28g7fn8AiBcCaMN/vri0Ubvr4GdQo1man5J+x
         lQ7R1TqhqnbMTARpVbLGy1omABcTKgPP+XF8t/Yt0pLiSTt65IW9kAZPxIMOeSKGRyqO
         l7IaL1HHzkzaZ4fuwUYaRlGJW8UzJK3G/TjYfXt0J8wfEO1LHqEcyD+v5HKVZyZOWGFR
         yGy7gNM+J6zJP8jrRmhUsU2ImYOGLKvvKAhiqU3iJY6SuHRBdEASAE/jAH5Y6dKaMb5k
         BivBwzVYHEjSfiD02CbC7U2AH4uIco+wl3FzrD3IiYS0Srhbx4s8bc0rKlm4joluCOER
         w3eg==
X-Gm-Message-State: AOAM530hsKC6eMCU6o7WHeQ1YAqmCkxGnIODG6Y2CrRMrLSngmlNhN2X
        oeK+/0WeEyJlZ88n0db3hhev2QX8MXrb77ezC+bOXg==
X-Google-Smtp-Source: ABdhPJxKwUr6Mj0BEDwdpy+SnRUQVHpSe65h55GAGFLd+Tz4e10Ihr4mDyeK2km1qRM342NbayRDmXZ3esgEpKlX8Gk=
X-Received: by 2002:a63:fe47:: with SMTP id x7mr5625761pgj.415.1642397077062;
 Sun, 16 Jan 2022 21:24:37 -0800 (PST)
MIME-Version: 1.0
References: <20211229112551.3483931-1-pumahsu@google.com> <Yd1tUKhyZf26OVNQ@kroah.com>
 <CAGCq0LZb8nQDvcz=LswWi4qKd-65ys6iPjTKh=46dVtYLDEUVw@mail.gmail.com> <Yd/g/ywBWZG7gF8v@kroah.com>
In-Reply-To: <Yd/g/ywBWZG7gF8v@kroah.com>
From:   Puma Hsu <pumahsu@google.com>
Date:   Mon, 17 Jan 2022 13:24:01 +0800
Message-ID: <CAGCq0LZ3i8VaMfRWNKvH_-ms0TgNqKA6f+Zx7M=iz1t_-smW+g@mail.gmail.com>
Subject: Re: [PATCH v3] xhci: re-initialize the HC during resume if HCE was set
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mathias.nyman@intel.com, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Albert Wang <albertccwang@google.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 13, 2022 at 4:21 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Thu, Jan 13, 2022 at 03:54:27PM +0800, Puma Hsu wrote:
> > On Tue, Jan 11, 2022 at 7:43 PM Greg KH <gregkh@linuxfoundation.org> wr=
ote:
> > >
> > > On Wed, Dec 29, 2021 at 07:25:51PM +0800, Puma Hsu wrote:
> > > > When HCE(Host Controller Error) is set, it means an internal
> > > > error condition has been detected. It needs to re-initialize
> > > > the HC too.
> > >
> > > What is "It" in the last sentence?
> >
> > Maybe I can change "It" to "Software", xHCI specification uses
> > "Software" when describing this.
>
> Please change it to something better :)

I will fix it in next patch version.

> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Puma Hsu <pumahsu@google.com>
> > >
> > > What commit id does this fix?
> >
> > This commit is not used to fix a specific commit. We find a condition
> > that when XHCI runs the resume process but the HCE flag is set, then
> > the Run/Stop bit of USBCMD cannot be set so that HC would not be
> > enabled. In fact, HC may already meet a problem at this moment.
> > Besides, in xHCI requirements specification revision 1.2, Table 5-21
> > BIT(12) claims that Software should re-initialize the xHC when HCE is
> > set. Therefore, I think this commit could be the error handling for
> > HCE.
>
> So this problem has been there since the driver was first added to the
> kernel?  Should it go to stable kernels as well?  If so, how far back in
> time?

I think XHCI hasn=E2=80=99t handled HCE, so yes this may be a long problem.
I have cced stable@vger.kernel.org for stable backporting, but I=E2=80=99m =
not sure
how far it should backport since it seems this might be a rare case if no o=
ne
reported this issue?

> > > > ---
> > > > v2: Follow Sergey Shtylyov <s.shtylyov@omp.ru>'s comment.
> > > > v3: Add stable@vger.kernel.org for stable release.
> > > >
> > > >  drivers/usb/host/xhci.c | 4 ++--
> > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> > > > index dc357cabb265..ab440ce8420f 100644
> > > > --- a/drivers/usb/host/xhci.c
> > > > +++ b/drivers/usb/host/xhci.c
> > > > @@ -1146,8 +1146,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool h=
ibernated)
> > > >               temp =3D readl(&xhci->op_regs->status);
> > > >       }
> > > >
> > > > -     /* If restore operation fails, re-initialize the HC during re=
sume */
> > > > -     if ((temp & STS_SRE) || hibernated) {
> > > > +     /* If restore operation fails or HC error is detected, re-ini=
tialize the HC during resume */
> > > > +     if ((temp & (STS_SRE | STS_HCE)) || hibernated) {
> > >
> > > But if STS_HCE is set on suspend, that means the suspend was broken s=
o
> > > you wouldn't get here, right?
> >
> > In xhci_suspend(), it seems doesn't really check whether STS_HCE is
> > set and then break the suspend(The only case for checking HCE is when
> > STS_SAVE setting failed). So suspend function may be still able to
> > finish even if HCE is set? Then xhci_resume will still be called.
>
> Is this a problem?

It could be, but I'm not sure and I think it may be not so serious if
HCE was raised
while suspend, because host controller doesn=E2=80=99t have job while suspe=
nd.
And we are
trying to recover it while resume.

> > > Or can the error happen between suspend and resume?
> > >
> > > This seems like a big hammer for when the host controller throws an
> > > error.  Why is this the only place that it should be checked for?  Wh=
at
> > > caused the error that can now allow it to be fixed?
> >
> > I believe this is not the only place that the host controller may set
> > HCE, the host controller may set HCE anytime it sees an error in my
> > opinion, not only in suspend or resume.
>
> Then where else should it be checked?  Where else will your silicon set
> this bit as part of the normal operating process?

We observed this flag while resume in our silicon so far. According to the =
XHCI
specification 4.24.1, =E2=80=9CSoftware should implement an algorithm for c=
hecking the
HCE flag if the xHC is not responding.=E2=80=9D, so maybe it would be bette=
r
to implement
a new API to recover host controller whenever the driver side finds no resp=
onse
from host controller in the future.

> thanks,
>
> greg k-h
